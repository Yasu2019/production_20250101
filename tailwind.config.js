

const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  // ここに他の設定を追加
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  // 例えば、デフォルトテーマを拡張する設定
  extend: {
    fontFamily: {
      sans: ['Inter var', ...defaultTheme.fontFamily.sans],
    },
  },
}