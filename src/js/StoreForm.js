import $ from "jquery"

class StoreForm {
  constructor(){
    $(document).ready(() => {
      this.formDefaults();
      this.categoryOptionEvent();
      this.multiGroupOptionEvent();
    });
  }

  formDefaults(){
    // Category Defaults
    $('.select-form-element').hover(function(){
      $('.select-form-element-options').removeClass('-hidden');
    }, function(){
      $('.select-form-element-options').addClass('-hidden');
    });
    var defaultCat = $('input[name="category"]').val();
    var defaultText = $(".select-form-element-option[data-value="+defaultCat+"]").text();
    $('.select-form-element-selection').text(defaultText);

    // Multi Group Select Defaults
    $(".mult-select-option").each(function(){
      var value = $(this).attr('data-value');
      if($('input[value='+ value +']').attr("checked") == "checked"){
        $(this).addClass("-active");
      }
    });
  }

  categoryOptionEvent(){
    $('.select-form-element-option').click(function(){
      var value = $(this).attr('data-value');
      var textValue = $(this).text();
      $('.select-form-element-selection').text(textValue);
      $('input[name="category"]').val(value);
      $('.select-form-element-options').addClass('-hidden');
    });
  }

  multiGroupOptionEvent(){
    $('.mult-select-option:not(".-display")').click(function(){
      var value = $(this).attr('data-value');
      if($(this).hasClass('-active')){
        $(this).removeClass('-active');
        $('input[value='+ value +']').removeAttr('checked');
      } else{
        $(this).addClass('-active');
        $('input[value='+ value +']').attr('checked', 'checked');
      }
    });
  }

}

export default StoreForm;
