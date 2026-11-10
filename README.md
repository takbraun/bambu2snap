# bambu2snap

Versión personal (takbraun) del convertidor Bambu → Snapmaker U1, basada en
[thadius83/bambu-to-snapmaker-u1](https://github.com/thadius83/bambu-to-snapmaker-u1).

Required Notice: Copyright thadius83 (https://github.com/thadius83)
Licencia: PolyForm Noncommercial 1.0.0 (ver `LICENSE`). Solo uso no comercial.

## Extras de esta versión
- Preset de impresora en red (Print/Send en OrcaSlicer) y todos los perfiles
  de calidad de la U1 disponibles al abrir el proyecto.
- Colores de filamento tomados de lo que tiene cargado la U1.
- Temperaturas por cabezal según el filamento cargado (`printer_loadout`).

## Instalar en un equipo o servidor
```bash
git clone git@github.com:takbraun/bambu2snap.git ~/bambu2snap
cd ~/bambu2snap && ./install.sh
nano bambu2snap.env          # IP de la impresora, puerto
systemctl --user restart bambu2snap
```
Abrir `http://<equipo>:8080`.

## Docker
```bash
cp bambu2snap.env.example bambu2snap.env   # IP de la impresora
docker compose up -d --build
```

## Botón Print en OrcaSlicer
Los archivos convertidos apuntan al preset `U13MF_PRINTER_PRESET`. Si ese preset
no existe en el OrcaSlicer donde abres el archivo, Orca solo ofrece
"Export G-code". Instálalo una vez en cada equipo y reinicia OrcaSlicer:

Windows (PowerShell):
```powershell
irm http://<equipo>:8080/install-orca-preset.ps1 | iex
```
macOS / Linux:
```bash
curl -fsSL http://<equipo>:8080/install-orca-preset.sh | sh
```
El JSON del preset también se puede descargar en `http://<equipo>:8080/api/orca-preset`.

## Actualizar
```bash
cd ~/bambu2snap && git pull && .venv/bin/pip install -r requirements.txt && systemctl --user restart bambu2snap
```
