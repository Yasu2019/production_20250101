// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from "@rails/actioncable"

// WebSocket URLを環境に応じて設定
const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
const wsHost = process.env.MINIPC === '1' ? '192.168.3.3' : window.location.hostname;
const wsPort = window.location.port;
const wsURL = `${wsProtocol}//${wsHost}:${wsPort}/cable`;

console.log("=== Creating ActionCable consumer with URL:", wsURL, "===");
const consumer = createConsumer(wsURL);

export default consumer;
