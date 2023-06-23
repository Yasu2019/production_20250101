source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]


end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"



end


gem 'ancestry'
gem 'dotenv-rails'

#gem 'devise-two-factor'
#gem 'rqrcode-rails3'
#gem 'devise-i18n-views'

#gem 'bootstrap-sass', '~> 3.3.6'

#https://qiita.com/345dvl/items/4bafb05964281079033e
gem 'cssbundling-rails'

gem "sass-rails", "~> 6"
#gem "sass-rails", "~> 5"

gem "puma_worker_killer"


gem 'simple_calendar', '~> 2.0'

gem 'rails-i18n'

gem 'kaminari'

gem "aws-sdk-s3", require: false

gem 'chartkick'
gem 'chartable'
gem 'groupdate'

gem 'ransack'

gem 'rubyzip', '2.3.0'


#https://techtechmedia.com/turbolinks-rails/
#【Rails】初心者向け！画面遷移の高速化を行うTurbolinksについて図を用いて詳しく解説
gem 'jquery-turbolinks'

#Webpacker から importmap-rails に移行した
#https://qiita.com/mishina2228/items/d4b9af22d0096ee451d7
gem 'cssbundling-rails'
gem 'propshaft'

gem 'foreman'

#railsでテンプレートからエクセル出力する方法
#https://intellectual-curiosity.tokyo/2018/09/21/rails%e3%81%a7%e3%83%86%e3%83%b3%e3%83%97%e3%83%ac%e3%83%bc%e3%83%88%e3%81%8b%e3%82%89%e3%82%a8%e3%82%af%e3%82%bb%e3%83%ab%e5%87%ba%e5%8a%9b%e3%81%99%e3%82%8b%e6%96%b9%e6%b3%95/

#railsで.xlsxを生成する
#https://qiita.com/shotay79/items/b66148f30496d43bcbfe

gem 'caxlsx'
gem 'caxlsx_rails'

#【Rails】Active Storageの基本情報と実装方法
#https://autovice.jp/articles/134


#PDF not previewable with rails active storage?
#https://stackoverflow.com/questions/56994871/pdf-not-previewable-with-rails-active-storage
gem 'poppler' 

#Active Storage previewer for Microsoft Office files
#https://github.com/basecamp/activestorage-office-previewer

gem "activestorage-office-previewer"



#【Ruby on Rails】CSVインポート
#https://qiita.com/seitarooodayo/items/c9d6955a12ca0b1fd1d4
gem 'roo'

#【Rails】もっと早く知りたかったデバッグ用gem 'better_errors','binding_of_caller'
#https://qiita.com/terufumi1122/items/a6f9a939dce25b2d9a3e

#※Dockerを使用している場合はもうひと手間必要
#BetterErrors::Middleware.allow_ip! "0.0.0.0/0"
#仮想環境を使っている方は、うまく動作しないようです。
#私はDockerを使っていますが、上記コードを追記してサーバー再起動で動作しました。

#【Rails】Rails開発者に絶対おすすめしたいデバッグ手法５選（初心者向け）
#https://techtechmedia.com/debug-summary-rail/


gem 'better_errors', group: :development
gem 'binding_of_caller', group: :development

#【Rails】 Pryを使ってデバッグをしてみよう！
#https://pikawaka.com/rails/pry

#pry-byebug を使ってRailsアプリをデバックする方法
#https://qiita.com/ryosuketter/items/da3a38d0d41c7e20a2d6

#railsのデバッグをDockerでやる方法
#https://zenn.dev/naoki0722/articles/f84f9195348a23


gem 'pry-rails', group: :development
gem 'pry-byebug', group: :development
gem 'pry-nav', group: :development


#https://qiita.com/jnchito/items/20fad64ab162b2c49bb9
gem 'devise','~> 4.9'

#devise日本語化
gem 'devise-i18n','~> 1.11.0' 

#ERB Formatter/Beautify
#https://marketplace.visualstudio.com/items?itemName=aliariff.vscode-erb-beautify
gem 'htmlbeautifier'

#【Rails】RuboCopの基本的な使用方法と出力の見方
#https://qiita.com/terufumi1122/items/ad55bf8713c0df053f58
gem 'rubocop', require:false
gem 'rubocop-rails', require:false

#https://stackoverflow.com/questions/41051423/how-do-i-auto-format-ruby-or-erb-files-in-vs-code
gem 'erb-formatter'