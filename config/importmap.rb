# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'

# 【rails】chartkick導入ガイド
# https://qiita.com/Yu_unI1/items/42ee303173739c26cf60
pin 'chartkick', to: 'chartkick.js'
pin 'Chart.bundle', to: 'Chart.bundle.js'

pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.14.0/modular/sortable.esm.js'

# Action Cable
pin "@rails/actioncable", to: "https://ga.jspm.io/npm:@rails/actioncable@7.1.3/app/assets/javascripts/actioncable.esm.js"

# Channels
pin "channels/consumer", to: "channels/consumer.js", preload: true
pin "channels/document_notifications_channel", to: "channels/document_notifications_channel.js", preload: true
pin "channels/index", to: "channels/index.js", preload: true
