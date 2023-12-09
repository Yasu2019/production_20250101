# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

#【rails】chartkick導入ガイド
# https://qiita.com/Yu_unI1/items/42ee303173739c26cf60
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"

pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.14.0/modular/sortable.esm.js"

pin "tailwind", to: "tailwind.css"

