# Collabeyy — Real-Time Collaborative Text Editor

> **Note:** Collabeyy runs on **Node.js v20** and is tested on **Windows**.

---

## What Is This?

Collabeyy is an open-source, real-time, **peer-to-peer collaborative text editor** that runs in the browser. It is built entirely in JavaScript without any central database.

* **CRDT** (Conflict-Free Replicated Data Types) keeps all users in sync
* **WebRTC** (via PeerJS) sends changes directly between users — no server stores your text
* **SimpleMDE** provides the Markdown editor interface
* **Express** serves the app and acts as the PeerJS signaling server

---

## Prerequisites

| Tool    | Version              |
| ------- | -------------------- |
| Node.js | v20.x (tested)       |
| npm     | v9+                  |
| OS      | Windows (PowerShell) |

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

```text
http://localhost:3000
```

The terminal will stay open — that is normal. The server is running as long as the terminal is open.

To stop the server, press `Ctrl + C` in the terminal.

---

## Running Again (Restart)

If you get:

```text
EADDRINUSE: address already in use :::3000
```

a previous server is still running. Kill it first:

```powershell
# Find the PID using port 3000
netstat -ano | findstr :3000

# Kill it (replace 1234 with the actual PID)
taskkill /PID 1234 /F
```

Then run:

```powershell
npm run local
```

---

## Available Scripts

| Command         | Description                           |
| --------------- | ------------------------------------- |
| `npm run local` | Build with Webpack + start the server |
| `npm start`     | Start the server only (no rebuild)    |
| `npm run build` | Rebuild Webpack bundles only          |
| `npm test`      | Run Jasmine unit tests                |

---

## Node.js 20 Compatibility

The project is configured to run with Node.js 20 on Windows.

The following configuration updates are included:

| Issue                                   | Configuration                                                                     |
| --------------------------------------- | --------------------------------------------------------------------------------- |
| `ERR_OSSL_EVP_UNSUPPORTED` during build | Added `NODE_OPTIONS=--openssl-legacy-provider` to the `build` and `local` scripts |
| Webpack `mode` warning                  | Set `mode: 'development'` in `webpack.config.js`                                  |
| Bundle size warnings                    | Added `performance: { hints: false }` in `webpack.config.js`                      |
| Missing `glob` dependency               | Added `glob` to the project dependencies                                          |

---

## Known Warnings

You may see the following warning during the Webpack build:

```text
WARNING in ../node_modules/peerjs/dist/peerjs.min.js
Critical dependency: the request of a dependency is an expression
```

This warning comes from the PeerJS library and does not prevent the application from running.

---

## Project Structure

```text
collabeyy/
├── app.js              ← Express server entry point
├── lib/                ← Core application logic
│   ├── controller.js   ← Main coordinator between modules
│   ├── crdt.js         ← CRDT algorithm for conflict-free synchronization
│   ├── broadcast.js    ← WebRTC peer-to-peer messaging
│   ├── editor.js       ← SimpleMDE editor bindings
│   └── ...
├── views/              ← Pug HTML templates
├── public/             ← Static assets and compiled JavaScript bundles
├── webpack.config.js   ← Webpack build configuration
└── package.json        ← Dependencies and npm scripts
```

---

## How Collaboration Works

1. Open `http://localhost:3000` — you become the **host**.
2. Copy the share link shown at the top of the editor.
3. Send it to another person or open it in a second browser tab.
4. Both users can type simultaneously.
5. Changes are synchronized in real time between connected peers.

---

## Docker

Alternatively, you can run Collabeyy using Docker:

```powershell
docker build -t collabeyy .
docker run -p 3000:3000 collabeyy
```

Then open:

```text
http://localhost:3000
```

---

## License

ISC — See [LICENSE.txt](LICENSE.txt)
