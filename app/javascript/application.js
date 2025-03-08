// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@rails/actioncable"
import consumer from "channels/index"

console.log("=== Application.js loaded ===");

// グローバルにActionCableコンシューマーを設定
window.App = window.App || {};
window.App.cable = consumer;

// WebSocket接続状態を定期的にチェック
setInterval(() => {
  const isActive = window.App?.cable?.connection?.isActive?.() ?? false;
  console.log("=== WebSocket connection is active ===", isActive);
}, 5000);

// DOMが読み込まれたら通知システムを初期化
document.addEventListener('DOMContentLoaded', () => {
  console.log("=== DOM loaded, initializing notification system ===");

  // 通知コンテナを作成
  console.log("=== Creating notification container ===");
  const notificationContainer = document.createElement('div');
  notificationContainer.id = 'notification-container';
  notificationContainer.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    max-width: 400px;
    background-color: white;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    display: none;
  `;
  document.body.appendChild(notificationContainer);
  console.log("=== Notification container created ===");

  // グローバルに通知関数を定義
  window.showNotification = function(message, hasNewFiles = false, files = []) {
    console.log("=== showNotification called with:", { message, hasNewFiles, files }, "===");
    
    try {
      const container = document.getElementById('notification-container');
      if (!container) {
        console.error("=== Notification container not found ===");
        return;
      }

      // 通知内容を作成
      container.innerHTML = `
        <div style="padding: 15px;">
          <p style="margin: 0 0 10px 0;">${message}</p>
          ${hasNewFiles ? `
            <div id="file-list" style="display: none; margin: 10px 0;">
              <ul style="margin: 0; padding-left: 20px;">
                ${files.map(file => `<li>${file}</li>`).join('')}
              </ul>
            </div>
          ` : ''}
          <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">
            ${hasNewFiles ? `
              <button onclick="window.showFileList()" style="padding: 5px 10px;">表示</button>
            ` : ''}
            <button onclick="window.closeNotification()" style="padding: 5px 10px;">閉じる</button>
          </div>
        </div>
      `;

      // 通知を表示
      container.style.display = 'block';
      console.log("=== Notification displayed ===");

      // ファイルリスト表示関数を定義
      window.showFileList = function() {
        console.log("=== Showing file list ===");
        const fileList = document.getElementById('file-list');
        if (fileList) {
          fileList.style.display = 'block';
        }
      };

      // 通知を閉じる関数を定義
      window.closeNotification = function() {
        console.log("=== Closing notification ===");
        container.style.display = 'none';
      };
    } catch (error) {
      console.error("=== Error showing notification:", error, "===");
    }
  };

  console.log("=== Initialization complete ===");
});
