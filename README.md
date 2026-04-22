# GPX Route Explorer

## Folder Layout

Place `index.html` at your project root. The `Routes` folder sits beside it:

```
project-root/
├── index.html
└── Routes/
    ├── <Folder name as it will appear in Routes list>/
    │   ├── <any_name>.gpx              ← any single .gpx file (name doesn't matter)
    │   ├── image_file_locations.csv
    │   └── images/
    │       ├── pano_001.jpg
    │       └── ...
    └── <next folder name>/
        ├── <any_name>.gpx
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

```
["<folder name 1", "<folder name 2" ...]
```

---

## CSV Format

`image_file_locations.csv` — **no header row**, four columns:

```
longitude, latitude, elevation_metres, image_filename
```

Example:
```
2.3522,48.8566,35.2,frame_001.jpg
2.3601,48.8612,38.0,frame_002.jpg
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
| ▶ / ⏸ | Play / Pause auto-advance.  Click current image to view in StreetView |
| ⏩ | Jump to next image location |
| ⏭ | Jump to route end |
| Drag scrubber | Move to any position |
| `Space` | Play / Pause |
| `← →` | Step forward / back |
| `Home` / `End` | Jump to start / end |

Playback traverses the full route in ~2 minutes by default
(adjustable via `PLAY_DURATION` at the top of the script).

Here is the prompt used to start this development:

I would like to create an application that displays a gpx file on a map on the top, 
the route elevation profile in the middle, and images along the route at the bottom, with a slider control below the images that allows the user to move the position along
the route similar to the frame control on video players.  It would move a marker along the map, profile, and choose the image to display.

Each data folder contains a gpx, an images sub-folder containing street view images along the route, an image_file_locations.csv containing x,y,z,image_file_name.  Some locations may not have images.

The application would present the list of folders in a side panel.  Selecting the name of the folder would load the map and profile, with location marker at the beginning of the route and displaying the image at that location if it exists. 

Can you help me develop this?