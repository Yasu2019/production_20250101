const fs = require('fs');
const bcrypt = require('bcryptjs');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config();

const settings = {
  adminAuth: {
    type: "credentials",
    users: [{
      username: process.env.NODERED_USERNAME,
      password: bcrypt.hashSync(process.env.NODERED_PASSWORD, 8),
      permissions: "*"
    }]
  }
};

const dir = '/root/.node-red';
const file = path.join(dir, 'settings.js');

// ディレクトリが存在しない場合は作成する
if (!fs.existsSync(dir)){
    fs.mkdirSync(dir, { recursive: true });
}

fs.writeFileSync(file, `module.exports = ${JSON.stringify(settings, null, 2)}`);