# Conclave — Real-Time Collaborative Text Editor

> **Note:** This is a fork of the original [Conclave](https://github.com/conclave-team/conclave) project, updated to run on **Node.js v20** and **Windows**.

---

## What Is This?

Conclave is an open-source, real-time, **peer-to-peer collaborative text editor** that runs in the browser. It is built entirely in JavaScript without any central database.

- **CRDT** (Conflict-Free Replicated Data Types) keeps all users in sync
- **WebRTC** (via PeerJS) sends changes directly between users — no server stores your text
- **SimpleMDE** provides the Markdown editor interface
- **Express** serves the app and acts as the PeerJS signaling server

---

## Prerequisites

| Tool | Version |
|------|---------|
| Node.js | v20.x (tested) |
| npm | v9+ |
| OS | Windows (PowerShell) |

---

## Setup & Run

### 1. Install dependencies

```powershell
npm install
```

### 2. Build and start the server

```powershell
npm run local
```

This single command will:
1. Set the required OpenSSL flag for Node 20 compatibility
2. Build and bundle all JavaScript via Webpack
3. Start the Express server on **port 3000**

### 3. Open in browser

```
http://localhost:3000
```

The terminal will stay open — that is normal. The server is running as long as the terminal is open.

To stop the server, press `Ctrl + C` in the terminal.

---

## Running Again (Restart)

If you get `EADDRINUSE: address already in use :::3000`, a previous server is still running. Kill it first:

```powershell
# Find the PID using port 3000
netstat -ano | findstr :3000

# Kill it (replace 1234 with the actual PID)
taskkill /PID 1234 /F
```

Then run `npm run local` again.

---

## Available Scripts

| Command | Description |
|---------|-------------|
| `npm run local` | Build with Webpack + start the server (use this for local dev) |
| `npm start` | Start the server only (no rebuild) |
| `npm run build` | Rebuild Webpack bundles only |
| `npm test` | Run Jasmine unit tests |

---

## Fixes Applied (vs Original)

The original project was built for Node.js v14. The following changes were made to support **Node.js v20 on Windows**:

| Issue | Fix |
|-------|-----|
| `ERR_OSSL_EVP_UNSUPPORTED` error on build | Added `NODE_OPTIONS=--openssl-legacy-provider` to `build` and `local` scripts in `package.json` |
| Webpack `mode` warning | Set `mode: 'development'` in `webpack.config.js` |
| Bundle size warnings | Added `performance: { hints: false }` in `webpack.config.js` |
| Missing `glob` dependency | Added `glob` to dependencies via `npm install glob` |

---

## Known Warnings (Safe to Ignore)

```
WARNING in ../node_modules/peerjs/dist/peerjs.min.js
Critical dependency: the request of a dependency is an expression
```

This comes from the `peerjs` third-party library. It is harmless and cannot be fixed without modifying the library itself.

---

## Project Structure

```
conclave/
├── app.js              ← Express server entry point
├── lib/                ← All core logic (CRDT, editor, broadcast, etc.)
│   ├── controller.js   ← Main coordinator between all modules
│   ├── crdt.js         ← CRDT algorithm for conflict-free sync
│   ├── broadcast.js    ← WebRTC peer-to-peer messaging
│   ├── editor.js       ← SimpleMDE editor bindings
│   └── ...
├── views/              ← Pug HTML templates
├── public/             ← Static assets (CSS, compiled JS bundles)
├── webpack.config.js   ← Webpack build configuration
└── package.json        ← Dependencies and npm scripts
```

---

## How Collaboration Works

1. Open `http://localhost:3000` — you are the **host**
2. Copy the share link shown at the top of the editor
3. Send it to another person (or open it in a second tab)
4. Both users can now type simultaneously — changes sync in real time

---

## Docker (Alternative)

```powershell
docker build -t conclave .
docker run -p 3000:3000 conclave
```

> The Dockerfile targets `node:14`. If you are using a newer base image, apply the same `NODE_OPTIONS` fix described above.

---

## License

ISC — See [LICENSE.txt](LICENSE.txt)
