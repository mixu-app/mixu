# Brand assets

The logo is the project's only visual asset. It is a flat, single-colour mark: an
open book whose negative space forms a lowercase `e`.

| File | Use |
|---|---|
| `logo.svg` | Primary mark on the original 1402×1122 canvas (padding preserved) |
| `logo-mark.svg` | Tightly cropped mark, for layouts that control their own spacing |
| `logo.png` | The supplied 1402×1122 RGBA original — source of truth |
| `favicon.svg` | 64×64 favicon, 10% breathing room, flips to a light tint in dark mode |
| `favicon-small.svg` | Simplified 64-pixel trace for 16 px contexts where detail fills in |
| `android-adaptive-foreground.svg` | Android adaptive-icon foreground, art inside the safe zone |
| `android-adaptive-background.svg` | Adaptive-icon background, solid brand colour |
| `android-monochrome.svg` | Themed-icon layer (Android 13+), single colour |

## Colour

- Mark: `#211431` (deep aubergine). The PNG samples to RGB 33/20/49 across 23% of
  the canvas; the trace uses one flat fill, so no gradient or shading exists.
- Dark-mode favicon tint: `#E7DDF6`.
- Background for the adaptive icon: the same `#211431`, with the mark reversed out
  in whatever the platform requires.

## Rules

1. **Do not recolour the mark** outside the two values above, and never apply a
   gradient. A one-colour mark is the point.
2. **Clear space** equals the height of the inner `e` counter on every side; the
   favicon already encodes 10%, which is the minimum.
3. **Do not redraw, rotate, outline or add effects.** If a context needs something
   different, ask for a new asset instead of editing this one.
4. **Trademarks are not licensed.** See `mixu-app/.github/TRADEMARKS.md`; the
   Apache-2.0 / MPL-2.0 licences cover code, not the name or the mark.
5. **Small sizes lose detail by design.** Below 24 px use `favicon-small.svg`;
   the inner counter closes up in `favicon.svg` at 16 px, which is expected.

## How the vectors were produced

`logo.png` is a raster export, so the SVGs are traced, not hand-drawn:

```sh
# full-quality trace of the alpha mask
python3 - <<'PY'
from PIL import Image
im = Image.open("logo.png").convert("RGBA")
m = Image.new("L", im.size, 255); m.paste(0, (0, 0), im.getchannel("A")); m.convert("1").save("mask.pbm")
PY
potrace -s --turdsize 4 --alphamax 1.0 --opttolerance 0.2 -o logo-trace.svg mask.pbm
```

Fidelity measured against the source: `logo-mark.svg` reaches IoU 0.996 (0.42% of
opaque pixels differ, all of them on antialiased edges). The favicon uses a 192 px
trace and the small variant a 64 px trace, so each stays under 1.3 KB.

If the mark is ever redrawn as true vector art, replace these files and keep the
filenames; nothing else references the tracing pipeline.
