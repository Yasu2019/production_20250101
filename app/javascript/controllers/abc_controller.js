import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const btn = document.getElementById("Btn");
    //要素がクリックされたら
    btn.addEventListener('click', function(){
    console.log('クリックされたよ👍')
});



  }
}
