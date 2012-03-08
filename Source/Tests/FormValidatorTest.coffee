formValidator = {}
describe 'Test FormValidator Object with Ext', ->
  beforeEach ->
    # Disable jQuery for theses tests and ensure that Ext is there:
    unless Ext?
      window.Ext = window.extDisabled
    if jQuery?
      window.jQueryDisabled = window.jQuery
      delete window.jQuery
      window.dollarDisabled = window.$
      delete window.$
    formValidator = new FormValidator()

  afterEach ->
    (Ext.fly element).remove() for element in (Ext.select '.' + formValidator.errorClass).elements
    # Restore jQuery:
    window.jQuery = window.jQueryDisabled
    delete window.jQueryDisabled
    window.$ = window.dollarDisabled
    delete window.dollarDisabled

  it 'validate for input field containing number validates for validate-number', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '100'
      cls: 'validate-number'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing text does not validate for validate-number', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: 'lalala'
      cls: 'validate-number'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing number 12 validates for validate-number-range-min12', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '12'
      cls: 'validate-number validate-number-range validate-number-range-min12'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing number 12 validates for validate-number-range-min11', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '12'
      cls: 'validate-number validate-number-range validate-number-range-min11'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing number 10 does not validate for validate-number-range-min11', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '10'
      cls: 'validate-number validate-number-range validate-number-range-min12'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing number 10 does not validate for validate-number-range-1-8', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '10'
      cls: 'validate-number validate-number-range validate-number-range-1-8'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing number 10 does not validate for validate-number-range-1-11', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '10'
      cls: 'validate-number validate-number-range validate-number-range-1-11'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing text validates for validate-notEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '100'
      cls: 'validate-notEmpty'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing nothing does not validate for validate-notEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: ''
      cls: 'validate-notEmpty'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing email-address validates for validate-email', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: 'a.lappe@kuehlhaus.com'
      cls: 'validate-email'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing text does not validate for validate-email', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: 'my email'
      cls: 'validate-email'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing text with min-length validates for validate-length', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '1234'
      cls: 'validate-length validate-length-min4'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing text longer than min-length validates for validate-length and validate-length-min', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '12345'
      cls: 'validate-length validate-length-min4'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing text shorter than min-length does not validate for validate-length and validate-length-min', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '123'
      cls: 'validate-length validate-length-min4'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing nothing validates for validate-length if validate-length-allowEmpty is set', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: ''
      cls: 'validate-length validate-length-min4 validate-length-allowEmpty'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for select field with selected option does validate for validate-select-noLabel', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'select'
      name: 'test'
      id: 'test100'
      cls: 'validate-select validate-select-noLabel'
      cn: [
        { tag: 'option', value: '10', html: '10', selected: 'selected' }
        { tag: 'option', value: '-', html: 'A label…' }
      ]
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for select field with label as selected option does not validate for validate-select-noLabel', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'select'
      name: 'test'
      id: 'test100'
      cls: 'validate-select validate-select-noLabel'
      cn: [
        # first one is selected by default…
        { tag: 'option', value: '-', html: 'A label…' }
        { tag: 'option', value: '10', html: '10' }
      ]
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for select field with label (--) as selected option does not validate for validate-select-noLabel', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'select'
      name: 'test'
      id: 'test100'
      cls: 'validate-select validate-select-noLabel'
      cn: [
        # first one is selected by default…
        { tag: 'option', value: '--', html: 'A label…' }
        { tag: 'option', value: '10', html: '10' }
      ]
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for select field with dash in value as selected option validates for validate-select-noLabel', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'select'
      name: 'test'
      id: 'test100'
      cls: 'validate-select validate-select-noLabel'
      cn: [
        # first one is selected by default…
        { tag: 'option', value: 'all-users', html: 'A label…' }
        { tag: 'option', value: '10', html: '10' }
      ]
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for multiple select field and no selected option does not validate for validate-select-notEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'select'
      multiple: 'multiple'
      name: 'test'
      id: 'test100'
      cls: 'validate validate-select validate-select-notEmpty'
      cn: [
        # first one is selected by default…
        { tag: 'option', value: 'all-users', html: 'A label…' }
        { tag: 'option', value: '10', html: '10' }
      ]
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for multiple select field and no selected option validates for validate-select-notEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'select'
      multiple: 'multiple'
      name: 'test'
      id: 'test100'
      cls: 'validate validate-select validate-select-notEmpty'
      cn: [
        # first one is selected by default…
        { tag: 'option', value: 'all-users', html: 'A label…' }
        { tag: 'option', value: '10', html: '10', selected: 'selected' }
      ]
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for select field with selected option having empty value does not validate fir validate-select-notEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'select'
      multiple: 'multiple'
      name: 'test'
      id: 'test100'
      cls: 'validate validate-select validate-select-notEmpty'
      cn: [
        # first one is selected by default…
        { tag: 'option', value: '', html: 'A label…' }
      ]
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()


  it 'validate for input field containing text with max-length validates for validate-length and validate-length-max', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '1234'
      cls: 'validate validate-length validate-length-max4'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing text longer than max-length does not validate for validate-length and validate-length-max', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '12345'
      cls: 'validate validate-length validate-length-max4'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing text in a wrong format does not validate for validate-date', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '21-01-01'
      cls: 'validate validate-date'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing invalid date does not validate for validate-date', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '32.01.2011'
      cls: 'validate validate-date'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing valid date does validate for validate-date', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '21.11.2011'
      cls: 'validate validate-date'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for input field containing invalid time does not validate for validate-time and validate-allowEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '11.21'
      cls: 'validate validate-time validate-allowEmpty'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for input field containing invalid time does not validate for validate-time and validate-allowEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '111'
      cls: 'validate validate-time validate-allowEmpty'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for empty input field does validate for validate-time and validate-allowEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: ''
      cls: 'validate validate-time validate-allowEmpty'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for empty input field does not validate for validate-time', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: ''
      cls: 'validate validate-time'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()
 
  it 'validate for valid time format in input field does validate for validate-time and validate-allowEmpty', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'text'
      value: '12:39'
      cls: 'validate validate-time validate-allowEmpty'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

  it 'validate for unchecked checkbox does not validate for validate-checkbox', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'checkbox'
      cls: 'validate validate-checkbox'
    (expect (formValidator.validate Ext.get 'test100')).toEqual false
    (Ext.fly 'test100').remove()

  it 'validate for checked checkbox does validate for validate-checkbox', ->
    Ext.DomHelper.append (Ext.select 'body').elements[0],
      tag: 'input'
      id: 'test100'
      type: 'checkbox'
      checked: 'checked'
      cls: 'validate validate-checkbox'
    (expect (formValidator.validate Ext.get 'test100')).toEqual true
    (Ext.fly 'test100').remove()

describe 'Test FormValidator Object with jQuery', ->
  beforeEach ->
    # Disable jQuery for theses tests and ensure that Ext is there:
    unless jQuery?
      window.jQuery = window.jQueryDisabled
      window.$ = window.dollarDisabled
    if Ext?
      window.extDisabled = window.Ext
      delete window.Ext
    formValidator = new FormValidator()
    unless (typeof Ext) is 'undefined' then delete Ext
    formValidator = new FormValidator()

  afterEach ->
    (jQuery element).remove() for element in (jQuery '.' + formValidator.errorClass)
    # Restore Ext:
    window.Ext = window.extDisabled
    delete window.extDisabled

  it 'validate for input field containing number validates for validate-number', ->
    (jQuery 'body').append '<input id="test100" type="text" value="100" class="validate-number" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing text does not validate for validate-number', ->
    (jQuery 'body').append '<input id="test100" type="text" value="lalala" class="validate-number" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing number 12 validates for validate-number-range-min12', ->
    (jQuery 'body').append '<input id="test100" type="text" value="12" class="validate-number validate-number-range -validate-number-range-min12" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing number 12 validates for validate-number-range-min11', ->
    (jQuery 'body').append '<input id="test100" type="text" value="12" class="validate-number validate-number-range -validate-number-range-min11" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing number 10 does not validate for validate-number-range-min11', ->
    (jQuery 'body').append '<input id="test100" type="text" value="10" class="validate-number validate-number-range -validate-number-range-min11" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing number 10 does not validate for validate-number-range-1-8', ->
    (jQuery 'body').append '<input id="test100" type="text" value="10" class="validate-number validate-number-range -validate-number-range-1-8" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing number 10 does validate for validate-number-range-1-11', ->
    (jQuery 'body').append '<input id="test100" type="text" value="10" class="validate-number validate-number-range -validate-number-range-1-11" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing text validates for validate-notEmpty', ->
    (jQuery 'body').append '<input id="test100" type="text" value="100" class="validate-notEmpty" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing nothing does not validate for validate-notEmpty', ->
    (jQuery 'body').append '<input id="test100" type="text" value="" class="validate-notEmpty" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing email-address validates for validate-email', ->
    (jQuery 'body').append '<input id="test100" type="text" value="a.lappe@kuehlhaus.com" class="validate-email" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing text does not validate for validate-email', ->
    (jQuery 'body').append '<input id="test100" type="text" value="my email" class="validate-email" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing text with min-length validates for validate-length', ->
    (jQuery 'body').append '<input id="test100" type="text" value="1234" class="validate-length validate-length-min4" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing text longer than min-length validates for validate-length and validate-length-min', ->
    (jQuery 'body').append '<input id="test100" type="text" value="12345" class="validate-length validate-length-min4" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing text shorter than min-length does not validate for validate-length and validate-length-min', ->
    (jQuery 'body').append '<input id="test100" type="text" value="123" class="validate-length validate-length-min4" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing nothing validates for validate-length if validate-length-allowEmpty is set', ->
    (jQuery 'body').append '<input id="test100" type="text" value="" class="validate-length validate-length-min4 validate-length-allowEmpty" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for select field with selected option does validate for validate-select-noLabel', ->
    elements = """
      <select name="test" id="test100" class="validate-select validate-select-noLabel">'
        <option value="10" selected="selected">10</option>
        <option value="-">A Label…</option>
      </select>
    """
    (jQuery 'body').append elements
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for select field with label as selected option does not validate for validate-select-noLabel', ->
    # first option is selected by default…
    elements = """
      <select name="test" id="test100" class="validate-select validate-select-noLabel">'
        <option value="-">A Label…</option>
        <option value="10">10</option>
      </select>
    """
    (jQuery 'body').append elements
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for select field with label (--) as selected option does not validate for validate-select-noLabel', ->
    # first option is selected by default…
    elements = """
      <select name="test" id="test100" class="validate-select validate-select-noLabel">'
        <option value="--">A Label…</option>
        <option value="10">10</option>
      </select>
    """
    (jQuery 'body').append elements
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for select field with dash in value as selected option validates for validate-select-noLabel', ->
    # first option is selected by default…
    elements = """
      <select name="test" id="test100" class="validate-select validate-select-noLabel">'
        <option value="all-users">A Label…</option>
        <option value="10">10</option>
      </select>
    """
    (jQuery 'body').append elements
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for multiple select field and no selected option does not validate for validate-select-notEmpty', ->
    # first option is selected by default…
    elements = """
      <select name="test" id="test100" class="validate-select validate-select-notEmpty" multiple="multiple">'
        <option value="all-users">A Label…</option>
        <option value="10">10</option>
      </select>
    """
    (jQuery 'body').append elements
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for multiple select field and no selected option validates for validate-select-notEmpty', ->
    elements = """
      <select name="test" id="test100" class="validate-select validate-select-notEmpty" multiple="multiple">'
        <option value="all-users">A Label…</option>
        <option value="10" selected="selected">10</option>
      </select>
    """
    (jQuery 'body').append elements
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for select field with selected option having empty value does not validate fir validate-select-notEmpty', ->
    elements = """
      <select name="test" id="test100" class="validate-select validate-select-notEmpty" multiple="multiple">'
        <option value="">A Label…</option>
      </select>
    """
    (jQuery 'body').append elements
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing text with max-length validates for validate-length and validate-length-max', ->
    (jQuery 'body').append '<input type="text" id="test100" value="1234" class="validate validate-length validate-length-max4" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing text longer than max-length does not validate for validate-length and validate-length-max', ->
    (jQuery 'body').append '<input type="text" id="test100" value="12345" class="validate validate-length validate-length-max4" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing text in a wrong format does not validate for validate-date', ->
    (jQuery 'body').append '<input type="text" id="test100" value="21-01-01" class="validate validate-date" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing invalid date does not validate for validate-date', ->
    (jQuery 'body').append '<input type="text" id="test100" value="32.01.2011" class="validate validate-date" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing valid date does validate for validate-date', ->
    (jQuery 'body').append '<input type="text" id="test100" value="21.11.2011" class="validate validate-date" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for input field containing invalid time does not validate for validate-time and validate-allowEmpty', ->
    (jQuery 'body').append '<input type="text" id="test100" value="11.21" class="validate validate-time validate-allowEmpty" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for input field containing invalid time does not validate for validate-time and validate-allowEmpty', ->
    (jQuery 'body').append '<input type="text" id="test100" value="111" class="validate validate-time validate-allowEmpty" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for empty input field does validate for validate-time and validate-allowEmpty', ->
    (jQuery 'body').append '<input type="text" id="test100" value="" class="validate validate-time validate-allowEmpty" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for empty input field does not validate for validate-time', ->
    (jQuery 'body').append '<input type="text" id="test100" value="" class="validate validate-time" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()
 
  it 'validate for valid time format in input field does validate for validate-time and validate-allowEmpty', ->
    (jQuery 'body').append '<input type="text" id="test100" value="12:39" class="validate validate-time validate-allowEmpty" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()

  it 'validate for unchecked checkbox does not validate for validate-checkbox', ->
    (jQuery 'body').append '<input type="checkbox" id="test100" class="validate validate-checkbox" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual false
    (jQuery '#test100').remove()

  it 'validate for checked checkbox does validate for validate-checkbox', ->
    (jQuery 'body').append '<input type="checkbox" checked="checked" id="test100" class="validate validate-checkbox" />'
    (expect (formValidator.validate jQuery '#test100')).toEqual true
    (jQuery '#test100').remove()
