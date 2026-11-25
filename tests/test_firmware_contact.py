import re
import unittest
from pathlib import Path


FIRMWARE = Path(__file__).parents[1] / "firmware" / "egg-freshness-tracker.yaml"


def top_level_section(config: str, name: str) -> str:
    match = re.search(
        rf"(?ms)^{re.escape(name)}:\n((?:[ \t]+.*\n|[ \t]*\n)*)",
        config,
    )
    if not match:
        raise AssertionError(f"Missing top-level section: {name}")
    return match.group(1)


def nested_entry(section: str, name: str) -> str:
    match = re.search(
        rf"(?ms)^  - id: {re.escape(name)}\n(.*?)(?=^  - id: |\Z)",
        section,
    )
    if not match:
        raise AssertionError(f"Missing entry: {name}")
    return match.group(1)


class ContactReportingTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.config = FIRMWARE.read_text()

    def test_api_reconnect_records_last_contact(self) -> None:
        api = top_level_section(self.config, "api")
        self.assertIn("on_client_connected:", api)
        self.assertIn("- script.execute: record_contact", api)

    def test_first_home_assistant_time_sync_records_contact(self) -> None:
        time = top_level_section(self.config, "time")
        self.assertIn("platform: homeassistant", time)
        self.assertIn("- script.execute: record_contact", time)

    def test_contact_timestamp_requires_a_valid_clock(self) -> None:
        script = top_level_section(self.config, "script")
        record_contact = nested_entry(script, "record_contact")
        self.assertIn("if (now.is_valid())", record_contact)
        self.assertIn("id(last_updated).publish_state(now.timestamp)", record_contact)

    def test_local_refresh_does_not_change_last_contact(self) -> None:
        script = top_level_section(self.config, "script")
        refresh = nested_entry(script, "refresh")
        self.assertNotIn("last_updated", refresh)


if __name__ == "__main__":
    unittest.main()
