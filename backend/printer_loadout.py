"""File I/O y resolución de temperatura por toolhead."""
from __future__ import annotations
import json
from pathlib import Path
from models import PrinterLoadout, ToolheadFilament, RuleDefinition
from rules_engine import FilamentContext, find_matches

DEFAULT_TEMP = "220"

def load_loadout(path: Path) -> PrinterLoadout | None:
    if not path.exists():
        return None
    try:
        return PrinterLoadout.model_validate(json.loads(path.read_text()))
    except Exception:
        return None

def save_loadout(path: Path, loadout: PrinterLoadout) -> None:
    path.write_text(loadout.model_dump_json(indent=2))

def resolve_toolhead_temperatures(
    loadout: PrinterLoadout,
    rules: list[RuleDefinition],
) -> tuple[list[str], list[str]]:
    """Devuelve (nozzle_temp_per_slot, initial_layer_temp_per_slot), 4 elementos."""
    temps, temps_initial = [], []
    for slot in loadout.slots:
        if not slot or not any([slot.filament_type, slot.settings_id_contains, slot.vendor]):
            temps.append(DEFAULT_TEMP)
            temps_initial.append(DEFAULT_TEMP)
            continue
        ctx = FilamentContext(
            settings_ids=(slot.settings_id_contains or "",),
            vendors=(slot.vendor or "",),
            types=(slot.filament_type or "",),
            base_profile="",
        )
        temp = temp_init = None
        for rule, _ in find_matches(rules, ctx):  # ascending priority → last wins
            ov = rule.overrides
            if "nozzle_temperature" in ov:
                v = ov["nozzle_temperature"]
                temp = str(v[0] if isinstance(v, list) else int(v) if isinstance(v, (int, float)) else v)
            if "nozzle_temperature_initial_layer" in ov:
                v = ov["nozzle_temperature_initial_layer"]
                temp_init = str(v[0] if isinstance(v, list) else int(v) if isinstance(v, (int, float)) else v)
        temps.append(temp or DEFAULT_TEMP)
        temps_initial.append(temp_init or temp or DEFAULT_TEMP)
    return temps, temps_initial
