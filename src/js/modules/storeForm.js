import $ from 'jquery';

class StoreForm {

  constructor(){
    this.initForm()
    this.initEvents()
  }

  initForm(){
    console.log("initForm");
    //Category Defaults
    $('.select-form-element').hover( () => {
      $('.select-form-element-options').removeClass('-hidden');
    }, () => {
      $('.select-form-element-options').addClass('-hidden');
    });

    let defaultCat = $('input[name="category"]').val();
    let defaultText = $(`.select-form-element-option[data-value=${defaultCat}]`).text();
    $('.select-form-element-selection').text(defaultText);

    // Multi Group Select Defaults
    $(".mult-select-option").each( (i, el) =>{
      let value = $(el).attr('data-value');
      if($(`input[value=${value}]`).attr("checked") == "checked") {
        $(el).addClass("-active")
      }
    });
  }

  initEvents(){
    $('.select-form-element-option').click( function(){
      let value = $(this).attr('data-value');
      let textValue = $(this).text();
      $('.select-form-element-selection').text(textValue);
      $('input[name="category"]').val(value);
      $('.select-form-element-options').addClass('-hidden');
    });
    $('.mult-select-option:not(".-display")').click(function(){
      let value = $(this).attr('data-value');
      if($(this).hasClass('-active')){
        $(this).removeClass('-active');
        $("input[value=#{value}]").removeAttr('checked');
      } else {
        $(this).addClass('-active');
        $("input[value=#{value}]").attr('checked', 'checked');
      }
    });
  }
}

export default StoreForm;
