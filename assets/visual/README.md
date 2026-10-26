# Visual asset inventory and review — 26 October 2026

Status: **REVISE / awaiting Director review**, not approved final art.

## Source and rights record

No production PNG sprites existed in the repository before this rework. The earlier procedural buildings were rejected by the Director. `docs/screenshots/visual_before.png` preserves that rendered result; `visual_after.png` shows the integrated sprite rework.

`assets/visual/source_atlas.png` was newly generated with the built-in GPT Image tool on 2026-10-26, from an original Indonesian village sprite brief. The supplied village illustration informed architecture/mood and the game screenshot informed small-scale readability only. Neither reference was cut up, traced, imported as game art, or used as a static map. Generated content is a candidate, not a guarantee of historical accuracy or final art approval. Joglo, pendopo, gateway and clothing period accuracy remain research items.

## Actual integrated PNG assets

All paths below are relative to `assets/visual/sprites/`; all 16 are **AI-generated candidates**, not hand-authored or Director-approved final assets:

| PNG | Role |
|---|---|
| buildings/house.png | Bamboo/wood house with rumbia roof |
| buildings/joglo.png | Javanese house, raised central roof |
| buildings/pendopo.png | Open meeting pavilion |
| buildings/granary.png | Raised rice store and ladder |
| buildings/gate.png | Brick cultural gateway |
| agriculture/field.png | Flooded paddy plot |
| vegetation/palm.png | Coconut tree |
| vegetation/banana.png | Banana plant |
| vegetation/bamboo.png | Bamboo clump |
| vegetation/tree.png | Tropical broadleaf tree |
| props/fence.png | Bamboo fence segment |
| props/flowers.png | Garden with pot |
| characters/farmer.png | Caping farmer with hoe |
| characters/leader.png | Raras, terracotta clothing and gold sash |
| characters/citizen.png | Teal-clothed villager |
| props/bridge.png | Timber bridge with water base |

Ground grass/path/water tiles and selection outlines remain **code-drawn placeholders**. UI is native Godot Controls with square warm-colored borders, not final pixel-panel art. Resource/day/quest/character values are mock data. Idle is a one-pixel decorative bob, not a walk/work animation.

## Folder categories — saved source crops and runtime sprites

The complete original atlas remains `source_atlas.png`. All 16 elements have two transparent PNG versions with matching category/name paths:

- `source_crops/`: cropped at source resolution, before runtime resizing; alpha cleanup retained.
- `sprites/`: smaller nearest-resized files used by Godot.
- `buildings/`: house, joglo, pendopo, granary, gate (5).
- `agriculture/`: rice field (1).
- `vegetation/`: palm, banana, bamboo, tree (4).
- `props/`: fence, flowers/pot, bridge (3).
- `characters/`: farmer, leader, citizen (3).

Both versions are indexed by `sprite_manifest.json` through `texture`, `source_crop` and `category`. The atlas source is preserved unchanged. This filing request does not change the pending art-review status.

## Replace/import pipeline (implemented)

- `assets/visual/sprite_manifest.json` maps stable kind IDs to transparent PNG paths, dimensions and ground offsets. `scripts/visual/village_art.gd` creates independent Sprite2D instances. No procedural building fallback remains.
- Replace a PNG at its manifest path, or change `texture` to a new project-local PNG. Godot reimports automatically. Set `ground_offset` to align the ground-contact point. Horizontal pivot is image center, vertical pivot is bottom plus this offset. Footprints/layout and UI IDs are independent from the texture.
- PNG alpha required; avoid baked checkerboards/background. Nearest filtering is explicitly applied to world sprites and the viewport display. Mipmaps are off and PNGs import losslessly. World viewport is 640×360, displayed at 2× on 1280×720; grid currently 40×20 native. These are review-scene choices, not ratification of proposed production standards.
- `tools/slice_visual_atlas.gd` reproduces the 16 PNGs and manifest from the retained source. It uses measured rectangles because the generated atlas was 1254×1254 and did not obey the requested regular grid. It thresholds low alpha and nearest-resizes; never draws replacement sprites. Do not rerun over manually refined sprites without backing them up.
- Draw order uses ground crops below Y-ordered objects. Picking checks alpha so empty PNG padding does not select an object. Editing manifest dimensions alone does not rescale PNGs; replace/normalize the actual image.

## Concrete remaining art needs

1. Artist cleanup of these 16 candidates: stray edge pixels, consistent outline/palette and perspective; especially pavilion roof/base, foliage clusters, and character body scale. Nearest resizing is not equivalent to hand-authored pixel art.
2. `terrain_grass.png`, `terrain_dirt.png`, `terrain_water.png`: 40×20 transparent 2:1 tiles (or revised approved size), plus matching bank/corner transitions. Replace remaining ground placeholders.
3. `farmer_idle.png`, `leader_idle.png`, `citizen_idle.png`: consistent 2-frame sheets, 24×32 cells, foot pivot (12,32); then walk sheets only if separately authorized. Current static candidates have differing proportions.
4. `ui_panel.png`: 24×24 pixel border for StyleBoxTexture nine-patch and small resource icons; current native UI remains a functional mockup.

No further art family or mechanics should be expanded before Director review.

## Review and minimum verification

Open `project.godot` in Godot 4.7.2 and press F5 (`scenes/visual_village.tscn`). Legacy mechanics remain on `scenes/main.tscn` via F6.

Acceptance/manual checks: map dominates on entry; no permanent right panel; recognize house/joglo/pendopo/granary/gate and farmer/chief; click opaque parts of objects for details; Bangun toggles the build menu; Rumah/Sawah/Lumbung select a visual example without spending resources; Krisis pangan opens mockup; drag/scroll/Reset work; Esc closes detail/build panels; Space pauses idle. Compare screenshots at 1280×720 and judge Nusantara identity, simplicity, density and text legibility. Choose APPROVED, REVISE or REJECTED; this document cannot grant approval.

Observed: Godot 4.7.2 import/parser passed; Compatibility render on Intel Arc A530M succeeded; focused smoke test passed 15 checks, including actual mouse-event selection of Raras and hidden-start panels. AFTER screenshot visually inspected. Atlas slicing initially met sandbox log/certificate errors but wrote the PNGs; normal-access import/render completed without those errors. Android/touch gestures and Director acceptance of this rework are NOT TESTED. No broad mechanics regression suite was rerun; existing mechanics files were not changed by this task.
