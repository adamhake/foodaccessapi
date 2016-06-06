import $ from 'jquery';

class Flash {
  constructor(){
    this.initFlash();
  }

  initFlash(){
    setTimeout(() =>{
      $('.messages.-vanish').addClass('-vanished');
    }, 3000);
  }
}

export default Flash;
