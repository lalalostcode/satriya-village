# Approved Design Direction — Satriya Village

## Ratification and document status — 26 October 2026

This file preserves the approved vision baseline. The [Decision Register](DECISION_REGISTER.md) records subsequent explicit decisions, acceptance in principle, proposals, open questions, and source conflicts. [PRD v1.1](PRD.md) remains **DRAFT**, with direction accepted in principle; pilot/MVP scope and implementation are not approved by that acceptance. A02 gameplay audit remains **NOT TESTED**.

The Director explicitly confirmed that pause stops automatic simulation while allowing valid explicit player commands, and that ordinary citizens use an aggregate economy while important characters are simulated individually. Unresolved economy recovery mechanics, balancing, calendars, and performance numbers stay PROPOSED/OPEN. The complete vision below remains in the [roadmap](ROADMAP.md); future-feature approval is not a release commitment.

The six attribute names below remain the repository baseline. Their status differs from the handoff, which treats the names as proposed; that conflict is recorded under O08 in the Decision Register and has not been silently ratified by the v1.1 review.

## Reviewer baseline for planning — S12

The subsequent reviewer CONDITIONAL PASS is adopted as **PLANNING_BASELINE**, not explicit Director approval of scope or numbers. Use a one-village slice with simple wood collection, safe save/load, mouse/touch, one food quest with at least two outcomes, one named official, and a visible player character with one small interaction (FR19). Use provisional 13+, Indonesian, non-graphic content and gradual onboarding; this is not a store age rating. Budget-minimal is an operating assumption; work hours, nominal budget, PC and device specs remain TBD, not Rp0 or a promised release date. Android smoke follows stable basic input/gameplay; test device and minimum supported remain distinct. [GDD](MASTER_GDD.md), [TDD](TDD.md), [Execution Plan](AI_AGENT_EXECUTION_PLAN.md) and [Quality Gates](QUALITY_GATES.md) are drafts. All vision below stays retained; pilot/MVP scope and engineering gates remain separate.

## Premise
- First scenario: a custom village chief starting in a fictional Malang-area settlement around the political crisis of Tumapel in the early thirteenth century.
- Ken Dedes / Ken Arok / Kadiri are historical-literary inspiration, with sources and creative invention distinguished in narrative docs.
- Hybrid history: plausible historical line plus alternate outcomes; player can become vassal or independent monarch.
- Tone: cute isometric pixel-art, Indonesian culture, whimsical mystical elements; accessible to young players.
- Endgame vision: politically unify the fictionalized Nusantara world through multiple strategies; pilot limited to East Java.

## Approved systems — future vision, not MVP promise
- Landscape Android; Godot + GDScript.
- Real-time pause / 1x / 2x / 3x; chapter-based optional time jumps.
- Limited offline production; no offline war or major story event.
- NPCs semi-autonomous. Named characters have traits, 6 stats and dynamic personality.
- Village grid-building with managed workers; ordinary workers auto-assign, named characters can be assigned.
- Semi-autonomous government with bounded spending authority.
- Heavy consequences of defeat and potential return from exile.
- Simple dynasty for pilot, deeper succession later.
- Hybrid tactical battle with army types, commanders and skills.
- Open-field battles in separate arenas; siege on settlement map.
- Political intrigue, spying, covert operations, diplomacy.
- Region/world map plus detailed settlements; settlements can be manually controlled or delegated.
- Separate local storages with semi-automatic logistics.
- Group-based ordinary citizen economy, richer named-character economy.
- Advanced production chains, item quality; hybrid knowledge tree plus expert NPC requirements.
- Optional gradual tutorial quests and living history world events.

## Character stats (six)
Leadership, Diplomacy, Strategy, Administration, Courage, Spirituality.

## Monetization principle
Optional rewarded ads may speed limited activities; core story/strategic play must be available without ads. Underage audience requires careful policy/compliance review before ad integration.

## Design risk
This is a large game for one beginner developer. Build vertical slices with strict scope and prototypes. Approval of a feature's vision does NOT imply it is scheduled for first release.

## Confirmed visual proportion baseline — 27 October 2026

Direct Game Director instruction approves the current Nusantara pixel-art direction, while requiring scale/layout revision. The [Proporsi & Footprint rules](PROPORTIONS_FOOTPRINTS.md) capture the explicit initial baseline: visual tile 48×24, house/granary/minimum paddy 2×2, paddy variants 3×2/4×4, gate 3×1 with walkable center or large 3×2, pendopo 3×3 or main 4×4, important buildings at least one tier larger, main road and default gap 1 tile, sprite overhang allowed. This confirms direction and baseline, not individual historical claims, final composition acceptance or new mechanics scope.

## Active integration update — 27 October 2026

The Director explicitly authorized gradual visual/gameplay integration after the proportion baseline. The visual scene is now the playable F5 entry point using existing settlement, clock, inventory, workforce, character reports and persistence. This supersedes earlier visual-only/F6 separation statements. No new politics, dynasty, combat, economy or quest system is authorized by this integration. See [integration evidence and limitations](VISUAL_GAMEPLAY_INTEGRATION.md); human and Android acceptance remain outstanding.
