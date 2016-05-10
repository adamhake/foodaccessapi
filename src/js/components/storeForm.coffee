$ = require "jquery"

window.StoreForm = class StoreForm
  constructor: ->
    @initForm()
    @initEvents()


  initForm: ->
    ## Category Defaults
    $('.select-form-element').hover ->
      $('.select-form-element-options').removeClass '-hidden'
      , ->
        $('.select-form-element-options').addClass '-hidden'

    defaultCat = $('input[name="category"]').val()
    defaultText = $(".select-form-element-option[data-value="+defaultCat+"]").text()
    $('.select-form-element-selection').text defaultText

    # Multi Group Select Defaults
    $(".mult-select-option").each ->
      value = $(this).attr 'data-value'
      if $("input[value=#{value}]").attr("checked") == "checked"
        $(this).addClass "-active"

  initEvents: ->

    $('.select-form-element-option').click ->
      value = $(this).attr 'data-value'
      textValue = $(this).text()
      $('.select-form-element-selection').text textValue
      $('input[name="category"]').val value
      $('.select-form-element-options').addClass '-hidden'

    $('.mult-select-option:not(".-display")').click ->
      value = $(this).attr 'data-value'
      if $(this).hasClass '-active'
        $(this).removeClass '-active'
        $("input[value=#{value}]").removeAttr 'checked'
      else
        $(this).addClass '-active'
        $("input[value=#{value}]").attr 'checked', 'checked'
