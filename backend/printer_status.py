"""Read the filaments currently loaded in a networked Snapmaker U1.

The U1 runs Klipper/Moonraker and publishes its RFID / manually-entered
filament info in the ``print_task_config`` object.
"""
from __future__ import annotations

import json
import logging
import urllib.request
from dataclasses import dataclass

log = logging.getLogger("u13mf.printer_status")

_TIMEOUT_S = 3


@dataclass
class LoadedFilament:
    colour: str        # "#RRGGBB"
    filament_type: str  # e.g. "PLA"
    sub_type: str      # e.g. "Matte", "Silk", "Basic"
    vendor: str


def fetch_loaded_filaments(host: str) -> list[LoadedFilament] | None:
    """Return one entry per toolhead, or None if the printer can't be reached."""
    if not host:
        return None
    url = f"http://{host}/printer/objects/query?print_task_config"
    try:
        with urllib.request.urlopen(url, timeout=_TIMEOUT_S) as resp:
            data = json.load(resp)
        cfg = data["result"]["status"]["print_task_config"]
    except Exception as err:  # offline, timeout, unexpected payload
        log.warning("printer %s unreachable, keeping project colours: %s", host, err)
        return None

    rgba = cfg.get("filament_color_rgba") or []
    types = cfg.get("filament_type") or []
    subs = cfg.get("filament_sub_type") or []
    vendors = cfg.get("filament_vendor") or []
    out: list[LoadedFilament] = []
    for i, c in enumerate(rgba):
        c = str(c).strip().lstrip("#")
        if len(c) < 6:
            return None
        out.append(LoadedFilament(
            colour="#" + c[:6].upper(),
            filament_type=str(types[i]) if i < len(types) else "",
            sub_type=str(subs[i]) if i < len(subs) else "",
            vendor=str(vendors[i]) if i < len(vendors) else "",
        ))
    return out or None
