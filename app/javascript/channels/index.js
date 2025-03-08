// Import all the channels to be used by Action Cable
import consumer from "./consumer.js"
import "./document_notifications_channel.js"

console.log("=== Initializing ActionCable consumer ===");

// グローバルにActionCableコンシューマーを設定
window.App = window.App || {};
window.App.cable = consumer;

// Initialize notifications channel
try {
  console.log("=== Creating channel subscription ===");
  const subscription = consumer.subscriptions.create({ 
    channel: "DocumentNotificationsChannel"
  }, {
    initialized() {
      console.log("=== Channel initialized ===");
    },

    connected() {
      console.log("=== Connected to DocumentNotificationsChannel ===");
      console.log("=== Connection state:", consumer.connection.isActive(), "===");
      this.perform('check_for_new_files');
    },

    disconnected() {
      console.log("=== Disconnected from DocumentNotificationsChannel ===");
      console.log("=== Connection state:", consumer.connection.isActive(), "===");
      // 3秒後に再接続を試みる
      setTimeout(() => {
        console.log("=== Attempting to reconnect ===");
        consumer.connect();
      }, 3000);
    },

    received(data) {
      console.log("=== Received data from channel:", data, "===");
      console.log("=== Connection state:", consumer.connection.isActive(), "===");
      
      if (data.type === 'new_files' && Array.isArray(data.files) && data.files.length > 0) {
        console.log("=== New files detected:", data.files, "===");
        const message = "新規ファイルがあります。新規ファイル名を表示しますか？";
        
        // showNotification関数が利用可能か確認
        if (typeof window.showNotification === 'function') {
          console.log("=== Calling showNotification with message:", message, "and files:", data.files, "===");
          try {
            window.showNotification(message, true, data.files);
            console.log("=== showNotification called successfully ===");
          } catch (error) {
            console.error("=== Error calling showNotification:", error, "===");
            alert(message);
          }
        } else {
          console.error("=== showNotification function is not available ===");
          alert(message);
        }
      }
    },

    rejected() {
      console.error("=== Subscription was rejected ===");
      console.log("=== Connection state:", consumer.connection.isActive(), "===");
      // 3秒後に再接続を試みる
      setTimeout(() => {
        console.log("=== Attempting to reconnect after rejection ===");
        consumer.connect();
      }, 3000);
    }
  });

  console.log("=== Channel subscription created ===");
  console.log("=== Initial connection state:", consumer.connection.isActive(), "===");

  // 接続状態を定期的にチェック
  setInterval(() => {
    console.log("=== Current connection state:", consumer.connection.isActive(), "===");
  }, 5000);
} catch (error) {
  console.error("=== Error creating subscription:", error, "===");
}

console.log("=== Channel subscription created ===");
console.log("=== Initial connection state:", consumer.connection.isActive(), "===");

// 接続状態を定期的にチェック
setInterval(() => {
  console.log("=== Current connection state:", consumer.connection.isActive(), "===");
}, 5000);

// Export consumer for use in other files
export default consumer;
