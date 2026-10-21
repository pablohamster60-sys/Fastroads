# fastroads

This is a modded version of [slowroads.io](slowroads.io) that adds fast cars and some other stuff. I did not make the original game. The original game is at [slowroads.io](slowroads.io), and it was created by [anslo](https://twitter.com/anslogen). Unfortunately the cars in the original game are too slow and he did not make the source code public, so all we have to work with is the minified JS. Some notes:

- There is now a "Lambo" that can reach speeds of about 363 mph. It looks the same as the roadster and doesn't handle too well but it's fun
- There is a "Supercar" that can reach speeds up to about 6000 mph. It looks like the roadster as well and handles as well as a 6000 mph car can
- High-speed brake profiles are tuned for less abrupt stopping.
- In addition to the three difficulties ("casual", "normal", "hard") there is now "wide" and "straight." "Wide" generates wider roads, and "straight" generates a straight, flat, wide road.
- There is a graphics option called "ultra+" that increases the render distance. Tree placement now reads the matching terrain-vertex slope data at every supported render resolution.
- The road and terrain are streamed around the car as it moves, with the terrain lookahead increasing at higher speeds and pending grid updates caught up after fast movement. Terrain cells behind the car are retired and reused so long drives do not keep every generated section in memory. Respawns and terrain reloads reset the vehicle's target node before repositioning, avoiding stale road indices and lost lookahead. Physics steps also shrink at extreme speeds, and wheel ground checks retain road contact while terrain cells are loading.
- Terrain angles are bounded before they reach vehicle orientation math, and the extreme-speed steering ratio is capped to keep the vehicle stable when speed exceeds its profile. Landing contact accounts for the wheel radius so the vehicle settles cleanly instead of bouncing.
- Extreme-hill foliage uses more permissive slope limits for grass and trees while still keeping them off near-vertical faces. Extreme Hills Straight now uses the Hilly Straight terrain-generation settings with the hill height amplified by 1.5x, rather than the extreme terrain's extra resolutions and crater layers. Holding forward applies forward drive torque even while the car is rolling backward, so it can recover from steep uphill sections instead of relying on weak braking. The Supercar's acceleration and chassis pitch response are tuned to limit acceleration-induced wheelies while preserving its 6000 mph top-speed target.
- Right-drag on the game canvas to look around without locking the pointer; normal left-click mouse steering remains available. The sandbox menu includes a 0.1x-to-3x brake-force multiplier and a restore-defaults button.
- Press J to make the car jump. Press J again while airborne to stack another jump. Autodrive no longer respawns the car automatically after a wall collision or when it gets stuck off-road; manual resets still work. Sandbox creative flight uses W/S for forward/backward movement, A/D for strafing, Space to rise, and Shift to descend.

# Running

The files in this repo were obtained by saving what was served by slowroads.io. Python 3 is required. For local solo play, start the included server:

```bat
run-fastroads.bat
```

This local server listens only on `127.0.0.1`, so it is not exposed to the local network and does not need a Windows Firewall exception. Open `http://127.0.0.1:8000` on the same computer. Local mode is for solo play; it cannot host other devices.

## Online multiplayer

Online play uses a hosted HTTPS service, so other players connect to the host service rather than to your PC. The deployment configuration in `render.yaml` runs the game and room API together; multiplayer uses only Python's standard library.

Before deploying, make sure you have permission to host and redistribute every original game file and asset in this project. Do not publish or deploy the copied game bundle without that permission.

1. If you have permission, create a ZIP named `fastroads-source.zip` containing the project files and folders (including `static/`) and add it with `render.yaml` to a GitHub repository. Do not include `.venv/` or `.vscode/`.
2. Create a Render account, choose **New → Blueprint**, and connect that repository. Its build step extracts `fastroads-source.zip`; the service then runs the included Python server.
3. Open the HTTPS URL Render assigns to the service and share that same URL with everyone who will play. No one should use `127.0.0.1` to join someone else's game.
4. In the hosted game, open **Multiplayer**. Create a room and share its code, or enter the code to join. Everyone must use the same seed, scene, and terrain preset.

Rooms support up to 12 players. A disconnected player is removed after about two minutes; empty rooms are then cleared. Room state is held in memory and disappears when the hosted service restarts or redeploys. Keep the Render service to a single instance so all players use the same in-memory rooms.

For local solo play, `run-fastroads.bat` starts the server on port 8000. Close older server windows before starting it; older versions of the server listened on every network interface. The current launcher warns if an old server is still running.

# Contributing

Any contributions are welcome. I am working on improving the handling of the new cars and giving them textures. I am also naming minified variables as I figure out what they mean.
