# GPX Route Explorer

## Folder Layout

Place `index.html` at your project root. The `Routes` folder sits beside it:

```
project-root/
├── index.html
└── Routes/
    ├── Montagne-Noire/
    │   ├── route.gpx              ← any single .gpx file (name doesn't matter)
    │   ├── image_file_locations.csv
    │   └── images/
    │       ├── pano_001.jpg
    │       └── ...
    └── Canal-du-Midi/
        ├── canal.gpx
        ├── image_file_locations.csv
        └── images/
            └── ...
```

---

## routes_index.json (optional)

The app discovers route folders automatically by reading the `Routes/` directory
listing served by your local web server. No index file is needed.

If your server does **not** serve directory listings, you can create this file
as a fallback. It is a simple JSON array of folder names matching exactly:

```json
["Montagne-Noire", "Canal-du-Midi", "Another Route"]
```

---

## CSV Format

`image_file_locations.csv` — **no header row**, four columns:

```
longitude, latitude, elevation_metres, image_filename
```

Example:
```
2.3522,48.8566,35.2,view_001.jpg
2.3601,48.8612,38.0,view_002.jpg
```

- Images are loaded from the `images/` sub-folder of each route folder.
- Rows whose image file is missing are silently skipped.
- An image is displayed when the scrubber is within **250 m** of its location.

---

## Running the App

The app must be served by a local web server (not opened as a `file://` URL),
because it fetches files via `fetch()`.

**Python (simplest):**
```bash
cd project-root
python -m http.server 8080
```
Then open `http://localhost:8080` in your browser.

**Node / npx:**
```bash
npx serve .
```

**VS Code:** Install the *Live Server* extension, right-click `index.html` → *Open with Live Server*.

---

## Controls

| Button / Key | Action |
|---|---|
| ⏮ | Jump to route start |
| ⏪ | Jump to previous image location |
| ▶ / ⏸ | Play / Pause auto-advance |
| ⏩ | Jump to next image location |
| ⏭ | Jump to route end |
| Drag scrubber | Move to any position |
| `Space` | Play / Pause |
| `← →` | Step forward / back |
| `Home` / `End` | Jump to start / end |

Playback traverses the full route in ~12 seconds by default
(adjustable via `PLAY_DURATION` at the top of the script).
