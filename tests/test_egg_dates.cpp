// Host-side unit tests for firmware/egg_dates.h.
// Build and run: g++ -std=c++17 -Wall -Wextra -Icomponents/egg_dates tests/test_egg_dates.cpp -o /tmp/t && /tmp/t
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string>

#include "egg_dates.h"

static int failures = 0;
#define CHECK(cond)                                                      \
  do {                                                                   \
    if (!(cond)) {                                                       \
      std::cerr << "FAIL line " << __LINE__ << ": " #cond << std::endl; \
      failures++;                                                        \
    }                                                                    \
  } while (0)

static time_t utc(int y, int mo, int d, int h, int mi) {
  return (time_t)(egg::days_from_civil(y, mo, d)) * 86400 + h * 3600 + mi * 60;
}
static std::string iso(int32_t day) {
  char b[16];
  egg::format_iso(day, b, sizeof b);
  return b;
}
static std::string disp(int32_t day) {
  char b[16];
  egg::format_display(day, b, sizeof b);
  return b;
}

int main() {
  using namespace egg;
  // POSIX rule that ESPHome generates for Europe/Brussels.
  setenv("TZ", "CET-1CEST,M3.5.0,M10.5.0/3", 1);
  tzset();

  // Civil round trips, leap years.
  CHECK(days_from_civil(1970, 1, 1) == 0);
  CHECK(iso(days_from_civil(2028, 2, 29)) == "2028-02-29");
  CHECK(iso(days_from_civil(2028, 2, 29) + 1) == "2028-03-01");
  CHECK(iso(days_from_civil(2027, 2, 28) + 1) == "2027-03-01");
  CHECK(disp(days_from_civil(2026, 3, 5)) == "05.03.2026");
  CHECK(disp(NO_DATE) == "--.--.----");
  for (int32_t d = 1; d < 40000; d += 7) {
    Civil c = civil_from_days(d);
    CHECK(days_from_civil(c.year, c.month, c.day) == d);
  }

  // Local date around the spring-forward change (2026-03-29 02:00 -> 03:00).
  CHECK(iso(local_day_from_epoch(utc(2026, 3, 28, 22, 59))) == "2026-03-28");  // 23:59 CET
  CHECK(iso(local_day_from_epoch(utc(2026, 3, 28, 23, 0))) == "2026-03-29");   // 00:00 CET
  CHECK(iso(local_day_from_epoch(utc(2026, 3, 29, 21, 59))) == "2026-03-29");  // 23:59 CEST
  CHECK(iso(local_day_from_epoch(utc(2026, 3, 29, 22, 0))) == "2026-03-30");   // 00:00 CEST
  // Around the fall-back change (2026-10-25 03:00 -> 02:00).
  CHECK(iso(local_day_from_epoch(utc(2026, 10, 24, 22, 0))) == "2026-10-25");  // 00:00 CEST
  CHECK(iso(local_day_from_epoch(utc(2026, 10, 25, 22, 59))) == "2026-10-25"); // 23:59 CET
  CHECK(iso(local_day_from_epoch(utc(2026, 10, 25, 23, 0))) == "2026-10-26");  // 00:00 CET

  // Expiry spans a DST change in calendar days (not 24 h blocks).
  CHECK(iso(expiry_day(days_from_civil(2026, 3, 20), 28)) == "2026-04-17");
  CHECK(iso(expiry_day(days_from_civil(2026, 10, 20), 28)) == "2026-11-17");

  // Status boundaries with fresh=7, expiry=28 (example values only).
  const int32_t g = days_from_civil(2026, 3, 1);
  auto st = [&](int age) { return classify(true, g + age, g, 7, 28); };
  CHECK(st(0) == Status::FRESH);
  CHECK(st(6) == Status::FRESH);
  CHECK(st(7) == Status::STILL_OK);  // fresh ends at the threshold
  CHECK(st(27) == Status::STILL_OK);
  CHECK(st(28) == Status::EXPIRED);  // expired starts on the expiry date
  CHECK(st(100) == Status::EXPIRED);
  CHECK(st(-1) == Status::FUTURE_DATE);

  // Status across DST: gathered 2026-03-25, fresh 7, expiry 10 -> Still OK on 04-01, Expired on 04-04.
  const int32_t g2 = days_from_civil(2026, 3, 25);
  CHECK(classify(true, days_from_civil(2026, 4, 1), g2, 7, 10) == Status::STILL_OK);
  CHECK(classify(true, days_from_civil(2026, 4, 3), g2, 7, 10) == Status::STILL_OK);
  CHECK(classify(true, days_from_civil(2026, 4, 4), g2, 7, 10) == Status::EXPIRED);

  // Thresholds must both be set and consistent; clock and date must exist.
  CHECK(classify(true, g, g, 0, 28) == Status::NO_THRESHOLDS);
  CHECK(classify(true, g, g, 7, 0) == Status::NO_THRESHOLDS);
  CHECK(classify(true, g, g, 28, 28) == Status::BAD_THRESHOLDS);
  CHECK(classify(true, g, g, 30, 28) == Status::BAD_THRESHOLDS);
  CHECK(classify(true, g, NO_DATE, 7, 28) == Status::NO_GATHERED);
  CHECK(classify(false, g, g, 7, 28) == Status::NO_CLOCK);
  CHECK(std::strcmp(status_text(Status::STILL_OK), "STILL OK") == 0);

  // Double click: wake press counts as the first click.
  ClickCounter c;
  c.reset(true);
  CHECK(!c.is_double());
  c.press();
  CHECK(c.is_double());
  c.reset(false);
  c.press();
  CHECK(!c.is_double());
  c.press();
  CHECK(c.is_double());

  if (failures) return 1;
  std::cout << "all tests passed" << std::endl;
  return 0;
}
