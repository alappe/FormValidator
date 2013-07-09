###
 FormValidator…

 Copyright (c) 2012, Andreas Lappe <nd@off-pist.de>
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
 - Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 - Neither the name of the kuehlhaus AG nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###

# Usage:
# 
#   With ExtJS:
#   -----8<-----8<-----8<-----8<-----
# Ext.onReady ->
#   # Initialize
#   formValidator = new FormValidator()
#   # On blur of fields:
#   fields = for formField in (Ext.select '.validate').elements
#     (Ext.fly formField).on 'blur', (ev, field) ->
#       formValidator.validate (Ext.get field)
#   # On submit of form:
#   forms = for fform in (Ext.select '.form-validate').elements
#     (Ext.fly fform).on 'submit', (ev, form) ->
#       formValidator.form = true
#       formValidator.event = ev
#       formValidator.validate (Ext.get field) for field in (Ext.get form).select '.validate'
#   -----8<-----8<-----8<-----8<-----
#
#   With jQuery:
#   -----8<-----8<-----8<-----8<-----
#  (jQuery 'document').ready ->
#    # Initialize
#    formValidator = new window.FormValidator()
#    
#    # Check a whole form
#    checkForm = (form) ->
#      (jQuery form).on 'submit', (ev) ->
#        formValidator.form = true
#        formValidator.event = ev
#        formValidator.validate (jQuery field) for field in (jQuery form).find '.validate'
#
#    # Check a field
#    checkField = (field) ->
#      (jQuery formField).on 'blur', (ev) ->
#        formValidator.validate (jQuery @)
#
#    # Bindings:
#    #
#    # On blur of fields:
#    checkField formField for formField in (jQuery '.validate')
#    # On submit of form:
#    checkForm form for form in (jQuery '.form-validate')
#   
#   -----8<-----8<-----8<-----8<-----
#
window.FormValidator = class FormValidator
  # The class to apply if validation for the field fails
  invalidClass: 'invalid'

  # The class to apply to the box holding the error message
  errorClass: 'form-error'

  # A regular expression to match email addresses against
  regExEMail: /// ^
    ( # User
      ([^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*)
      |
      (\".+\")
    )
    @
    ( # Host including TLD
      (\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])
      |
      (([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,})
    )
  $ ///

  # A regular expression to match numbers (integers)
  regExNumber: /^\d+$/

  # Do we validate a whole form opposed to just a field?
  form: false

  # The event to cancel in case form validation fails
  event: undefined

  # Throw error messages?
  errorMessages: true

  # The current message
  message: ''

  # A stack of messages to choose from
  messages:
    email: 'Email-Adresse muss korrekt eingegeben werden!'
    minLength: 'Mindestlänge von | Zeichen!'
    maxLength: 'Maximale Länge von | Zeichen!'
    notEmpty: 'Feld muss ausgefüllt werden!'
    number: 'Wert muss ganzzahlig sein…'
    noLabel: 'Bitte treffen Sie eine Auswahl…'
    noSelectedOption: 'Bitte wählen Sie mindestens eine Kategorie aus…'
    dateFormat: 'Bitte im Format tt.mm.jjjj eingeben…'
    dateInvalid: 'Ungültiges Datum…'
    timeFormat: 'Bitte im Format ss:mm eingeben…'
    timeInvalid: 'Ungültige Uhrzeit…'
    minNumber: 'Zahl muss größer als | sein…'
    maxNumber: 'Zahl muss kleiner als | sein…'
    checkbox: 'Checkbox muss ausgewählt sein…'

  selectorEngine: undefined

  constructor: ->
    if jQuery?
      @selectorEngine = 'jQuery' if jQuery.fn.jquery.match /^1\.9.*$/
    else if Ext?
      @selectorEngine = 'Ext' if Ext.versions.core.version.match /^4\..*$/
    unless @selectorEngine?
      throw new Error('Neither jQuery nor Ext found… but I need a selector-engine to work!')

  # Check if given field has given class
  # 
  # @param {Element} field
  # @param {String} cls
  # @return {Boolean}
  _hasCls: (field, cls) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery field).hasClass cls
      when 'Ext' then (Ext.fly field).hasCls cls

  # Add given class to the given field
  #
  # @param {Element} field
  # @param {String} cls
  # @return {Boolean}
  _addCls: (field, cls) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery field).addClass cls
      when 'Ext' then (Ext.fly field).addCls cls

  # Remove given class from the given element
  #
  # @param {Element} field
  # @param {String} cls
  # @return void
  _removeCls: (field, cls) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery field).removeClass cls
      when 'Ext' then (Ext.fly field).removeCls cls

  # Get the parent of given Element
  #
  # @param {Element} field
  # @return {Element}
  _parent: (field) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery field).parent()
      when 'Ext' then (Ext.fly field).parent()

  # Create a given children inside the given parent
  #
  # @param {Element} parent
  # @param {Object} child
  # @return {Element}
  _createChild: (parent, child) ->
    switch @selectorEngine
      when 'jQuery'
        string = '<' + child.tag + ' class="' + child.cls + '"><div class="message">' + child.html + '</div></' + child.tag + '>'
        (jQuery parent).append string
      when 'Ext' then (Ext.fly parent).createChild child

  # Stop event propagation…
  #
  # @param {Event} ev
  # @return void
  _stopEvent: (ev) ->
    switch @selectorEngine
      when 'jQuery' then ev.preventDefault()
      when 'Ext' then ev.stopEvent()

  # Remove the given Element from DOM
  #
  # @param {Element} field
  # @return void
  _remove: (field) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery field).remove()
      when 'Ext' then (Ext.fly field).remove()

  # Select elements via CSS-selectors
  #
  # @param {Element} root
  # @param {String} selectors
  # @return {Array}
  _select: (root, selectors) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery root).find selectors
      when 'Ext' then ((Ext.fly root).select selectors).elements

  # Get value
  #
  # @param {Element} field
  # @return {String}
  _getValue: (field) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery field).val()
      when 'Ext' then (Ext.fly field).getValue()

  # Is this Internet Explorer?
  #
  # @return {Boolean}
  _isIE: ->
    switch @selectorEngine
      when 'jQuery' then jQuery.browser.msie
      when 'Ext' then Ext.isIE

  # Get all classes
  #
  # @param {Element} field
  # @return {String}
  _getClasses: (field) ->
    switch @selectorEngine
      when 'jQuery'
        if @_isIE() then (jQuery field).attr 'className' else (jQuery field).attr 'class'
      when 'Ext'
        if @_isIE() then (Ext.fly field).getAttribute 'className' else (Ext.fly field).getAttribute 'class'

  # Get selectedIndex
  #
  # @param {Element} field
  # @return {Number}
  _getSelectedIndex: (field) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery field).prop('selectedIndex')
      when 'Ext' then (Ext.fly field).dom.selectedIndex

  # Check of field has checked property set to true:
  #
  # @param {Element} field
  # @return {Boolean}
  _isChecked: (field) ->
    switch @selectorEngine
      when 'jQuery' then (jQuery field).is ':checked'
      when 'Ext' then @_getValue field

  _parseDate: (date, format) ->
    switch @selectorEngine
      # TODO: jQuery does not provide a real validation of Date formats
      # as Ext does. I tried to replicate the functionality, but a lot
      # of formats are not supported… add them as you see fit:
      when 'jQuery'
        switch format
          when 'd.m.Y'
            return null unless (date.match /^(\d+)\.(\d+)\.(\d+)$/)?
            regex = /^(\d+)\.(\d+)\.(\d+)$/
            day = (parseInt (date.replace regex, '$1'), 10) - 1
            month = (parseInt (date.replace regex, '$2'), 10) - 1
            year = (parseInt (date.replace regex, '$3'), 10) - 1
            return null if day > 30 or month > 11 or year < 1970 or year > 2060
            new Date year, month, day
          when 'm/d/Y' and date.match /^(\d+)\/(\d+)\/(\d+)$/
            regex = /^(\d+)\/(\d+)\/(\d+)$/
            day = date.replace regex, '$1'
            month = date.replace regex, '$2'
            year = date.replace regex, '$3'
            new Date year, month, day
          else
            null
      when 'Ext' then Ext.Date.parse date, format, true
  
  # Mark a field invalid
  # 
  # @param {Element} field
  # @return this
  markFieldInvalid: (field) ->

    # Set the invalidClass unless we already have it…
    (@_addCls field, @invalidClass) unless (@_hasCls field, @invalidClass)

    if @errorMessages is true
      @removeErrors field

      box = field.parent()
      # Only for steuerring to only have one error per line instead of
      # per field:
      if @selectorEngine is 'jQuery'
        relatedErrors = (jQuery field).parents('fieldset').find '.'+@errorClass
        if relatedErrors.length is 0
          @_createChild box,
            tag: 'div'
            cls: @errorClass
            html: @message
      else
        @_createChild box,
          tag: 'div'
          cls: @errorClass
          html: @message

      @_stopEvent @event if @form
      @

  # Mark field valid (and remove error messages in case they exist)
  #
  # @param {Element} field
  # @return this
  markFieldValid: (field) ->
    (@_removeCls field, @invalidClass) if (@_hasCls field, @invalidClass)
    @removeErrors field
    @

  # Remove error boxes
  #
	# @param {Element} field
	# @return this
  removeErrors: (field) ->
    @_remove el for el in (@_select (@_parent field), '.'+@errorClass)
    @

	# Validate field
	#
	# @param {Element} field
	# @return {Boolean}
  validate: (field) ->
    status = true

    # Not empty
    if (@_hasCls field, 'validate-notEmpty') and status
      if (@_getValue field).length < 1
        @message = @messages.notEmpty
        status = false

    # eMail
    if (@_hasCls field, 'validate-email') and status
      unless @regExEMail.test (@_getValue field)
        @message = @messages.email
        status = false

    # length
    if (@_hasCls field, 'validate-length') and status
      value = @_getValue field
      classes = @_getClasses field
      allowEmpty = if @_hasCls field, 'validate-length-allowEmpty' then true else false
      minLength = if (classes.match /validate-length-min/)? then (parseInt (classes.replace /.*validate-length-min(\d*).*/, '$1'), 10) else null
      maxLength = if (classes.match /validate-length-max/)? then (parseInt (classes.replace /.*validate-length-max(\d*).*/, '$1'), 10) else null

      if allowEmpty
        if value.length > 0 and length.length < minLength
          @message = @messages.length.replace /\|/, length
          status = false
      else
        # As soon as maxLength/minLength is not null, we know it has to be validated against
        if minLength? and value.length < minLength
          @message = @messages.minLength.replace /\|/, minLength
          status = false

        if maxLength? and value.length > maxLength
          @message = @messages.maxLength.replace /\|/, maxLength
          status = false

    # Numbers
    if (@_hasCls field, 'validate-number') and status
      unless @regExNumber.test (@_getValue field)
        @message = @messages.number
        status = false
      if (@_hasCls field, 'validate-number-range') and status
        classes = @_getClasses field
        min = if (classes.match /validate-number-range-min/)? then (parseInt (classes.replace /.*validate-number-range-min(\d*).*/, '$1'), 10) else null
        max = if (classes.match /validate-number-range-max/)? then (parseInt (classes.replace /.*validate-number-range-max(\d*).*/, '$1'), 10) else null
        # Alternate way to specify range:
        unless min? and max?
          if (classes.match /validate-number-range-\d-\d/)?
            min = parseInt (classes.replace /.*validate-number-range-(\d+).*/, '$1'), 10
            max = parseInt (classes.replace /.*validate-number-range-(\d+)-(\d+).*/, '$2'), 10

        value = parseInt (@_getValue field), 10
        # Now test against min/max if given:
        if min? and value < min
          @message = @messages.minNumber.replace /\|/, min - 1
          status = false
        if max? and value > max
          @message = @messages.maxNumber.replace /\|/, max + 1
          status = false

    # Select fields
    if (@_hasCls field, 'validate-select') and status
      # noLabel in select/option
      if @_hasCls field, 'validate-select-noLabel'
        fields = for option in @_select field, 'option'
          if option.selected and option.value.match /^-+$/
            @message = @messages.noLabel
            status = false
      # notEmpty in multiple select
      if @_hasCls field, 'validate-select-notEmpty'
        selectedIndex = @_getSelectedIndex field
        if selectedIndex is -1
          @message = @messages.noSelectedOption
          status = false

    # Date
    if (@_hasCls field, 'validate-date') and status
      date = @_getValue field
      # Not matching the regular date format dd.mm.yyyy
      unless date.match /\d{2}\.\d{2}\.\d{4}/
        @message = @messages.dateFormat
        status = false

      # Invalid date
      dt = @_parseDate date, 'd.m.Y'
      unless dt?
        @message = @messages.dateInvalid
        status = false

    # Time
    if (@_hasCls field, 'validate-time') and status
      time = @_getValue field
      # Not matching the time format hh:mm
      unless time.match /\d{2}:\d{2}/
        if @_hasCls field, 'validate-allowEmpty'
          if time.length isnt 0
            @message = @messages.timeFormat
            status = false
        else
          @message = @messages.timeFormat
          status = false
      else
        hours = (parseInt (time.replace /^(\d{2}):.*/, '$1'), 10)
        minutes = (parseInt (time.replace /^.*:(\d{2})$/, '$1'), 10)
        unless (hours >= 0 and hours <= 23) and (minutes >= 0 and minutes <= 59)
          @message = @messages.timeInvalid
          status = false

    # Checkbox
    if (@_hasCls field, 'validate-checkbox') and status
      unless @_isChecked field
        @message = @messages.checkbox
        status = false

    # Mark field as valid/invalid
    unless status then @markFieldInvalid field else @markFieldValid field

    # Return the final status
    status
