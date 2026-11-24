// Pure calendar-date logic for the egg freshness tracker (no ESPHome dependencies,
// so it is unit-tested on a normal computer: see tests/test_egg_dates.cpp).
//
// Dates are "day numbers": the count of calendar days since 1970-01-01 in the
// local calendar. Adding days to a date therefore never involves 24-hour
// arithmetic and is unaffected by daylight-saving changes (a day that is 23 or
// 25 hours long is still exactly one calendar day).
#pragma once

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <ctime>

namespace egg {

constexpr int32_t NO_DATE = 0;  // 1970-01-01 is never a valid gathered date

enum class Status : uint8_t {
  NO_CLOCK,        // clock never synchronised
  NO_GATHERED,     // gathered date not set yet
  NO_THRESHOLDS,   // user has not set both thresholds
  BAD_THRESHOLDS,  // fresh threshold must be smaller than expiry threshold
  FUTURE_DATE,     // gathered date is after today (wrong clock or wrong date)
  FRESH,
  STILL_OK,
  EXPIRED,
};

// Howard Hinnant's public-domain civil calendar algorithms.
inline int32_t days_from_civil(int y, unsigned m, unsigned d) {
  y -= m <= 2;
  const int era = (y >= 0 ? y : y - 399) / 400;
  const unsigned yoe = static_cast<unsigned>(y - era * 400);
  const unsigned doy = (153 * (m > 2 ? m - 3 : m + 9) + 2) / 5 + d - 1;
  const unsigned doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;
  return era * 146097 + static_cast<int32_t>(doe) - 719468;
}

struct Civil {
  int year;
  unsigned month;
  unsigned day;
};

inline Civil civil_from_days(int32_t z) {
  z += 719468;
  const int era = (z >= 0 ? z : z - 146096) / 146097;
  const unsigned doe = static_cast<unsigned>(z - era * 146097);
  const unsigned yoe = (doe - doe / 1460 + doe / 36524 - doe / 146096) / 365;
  const int y = static_cast<int>(yoe) + era * 400;
  const unsigned doy = doe - (365 * yoe + yoe / 4 - yoe / 100);
  const unsigned mp = (5 * doy + 2) / 153;
  const unsigned d = doy - (153 * mp + 2) / 5 + 1;
  const unsigned m = mp < 10 ? mp + 3 : mp - 9;
  return Civil{y + (m <= 2 ? 1 : 0), m, d};
}

// Local calendar date of a UTC timestamp, using the TZ environment variable
// (ESPHome sets it from `timezone: Europe/Brussels`).
inline int32_t local_day_from_epoch(time_t t) {
  struct tm tm_local;
  localtime_r(&t, &tm_local);
  return days_from_civil(tm_local.tm_year + 1900, tm_local.tm_mon + 1, tm_local.tm_mday);
}

// Expiry is calculated from the gathered date, not from the laying date.
inline int32_t expiry_day(int32_t gathered, int expiry_days) { return gathered + expiry_days; }

// Fresh ends at the fresh threshold: with a 7-day threshold, an egg gathered on
// the 1st is Fresh through the 7th and Still OK from the 8th. Expired starts on
// the expiry date itself.
inline Status classify(bool clock_ok, int32_t today, int32_t gathered, int fresh_days, int expiry_days) {
  if (!clock_ok) return Status::NO_CLOCK;
  if (gathered == NO_DATE) return Status::NO_GATHERED;
  if (fresh_days <= 0 || expiry_days <= 0) return Status::NO_THRESHOLDS;
  if (fresh_days >= expiry_days) return Status::BAD_THRESHOLDS;
  const int32_t age = today - gathered;
  if (age < 0) return Status::FUTURE_DATE;
  if (age < fresh_days) return Status::FRESH;
  if (age < expiry_days) return Status::STILL_OK;
  return Status::EXPIRED;
}

inline const char *status_text(Status s) {
  switch (s) {
    case Status::NO_CLOCK: return "NO CLOCK";
    case Status::NO_GATHERED: return "SET DATE";
    case Status::NO_THRESHOLDS: return "SET LIMITS";
    case Status::BAD_THRESHOLDS: return "BAD LIMITS";
    case Status::FUTURE_DATE: return "CHECK DATE";
    case Status::FRESH: return "FRESH";
    case Status::STILL_OK: return "STILL OK";
    case Status::EXPIRED: return "EXPIRED";
  }
  return "";
}

// Belgian display format DD.MM.YYYY, or "--.--.----" when unset.
inline void format_display(int32_t day, char *out, size_t n) {
  if (day == NO_DATE) {
    snprintf(out, n, "--.--.----");
    return;
  }
  const Civil c = civil_from_days(day);
  snprintf(out, n, "%02u.%02u.%04d", c.day, c.month, c.year);
}

// ISO format YYYY-MM-DD for Home Assistant.
inline void format_iso(int32_t day, char *out, size_t n) {
  if (day == NO_DATE) {
    snprintf(out, n, "unknown");
    return;
  }
  const Civil c = civil_from_days(day);
  snprintf(out, n, "%04d-%02u-%02u", c.year, c.month, c.day);
}

// Double-click detection: the click that woke the device from deep sleep counts
// as the first click.
struct ClickCounter {
  int clicks{0};
  void reset(bool woke_by_button) { clicks = woke_by_button ? 1 : 0; }
  void press() { clicks++; }
  bool is_double() const { return clicks >= 2; }
};

}  // namespace egg
