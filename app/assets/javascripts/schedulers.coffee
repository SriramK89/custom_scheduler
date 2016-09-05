# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
fixed_datetime = null

_loadFixedDateTime = ->
  repeat_units = parseInt($('#scheduler_repeat_unit').val())
  fixed_datetime_regex = /([\d*]{4})-([\d*]{2})-([\d*]{2})\s([\d*]{2}):([\d*]{2})/g
  matches = fixed_datetime_regex.exec(fixed_datetime)
  if matches != null
    year = parseInt(matches[1])
    month = parseInt(matches[2])
    day = parseInt(matches[3])
    hour = parseInt(matches[4])
    minute = parseInt(matches[5])
    year_dropdown = $('#fixedYear')
    month_dropdown = $('#fixedMonth')
    day_dropdown = $('#fixedDay')
    hour_dropdown = $('#fixedHour')
    minute_dropdown = $('#fixedMinute')
    if repeat_units < gon.repeat_units.minutes
      minute_dropdown.val(minute)
    if repeat_units < gon.repeat_units.hourly
      hour_dropdown.val(hour)
    if repeat_units < gon.repeat_units.daily
      day_dropdown.val(day)
    if repeat_units < gon.repeat_units.monthly
      month_dropdown.val(month)
    if repeat_units < gon.repeat_units.yearly
      year_dropdown.val(year)

_getDoubleDigit = (number) ->
  if number < 10
    return "0#{number}"
  else
    return "#{number}"

_formatNumber = (number) ->
  if (number % 10) == 1
    return "#{number}st"
  else if (number % 10) == 2
    return "#{number}nd"
  else if (number % 10) == 3
    return "#{number}rd"
  else
    return "#{number}th"

_showHelpText = ->
  repeat_units = parseInt($('#scheduler_repeat_unit').val())
  repeat_num = $('#scheduler_repeat_number').val()
  year = $('#fixedYear').val()
  month = _getDoubleDigit $('#fixedMonth').val()
  day = _getDoubleDigit $('#fixedDay').val()
  hour = _getDoubleDigit $('#fixedHour').val()
  minute = _getDoubleDigit $('#fixedMinute').val()
  help_text = 'This schedule will be carried out'
  switch repeat_units
    when gon.repeat_units.none
      help_text += " on #{day}-#{month}-#{year}(DD-MM-YYYY) at #{hour}:#{minute} hours."
    when gon.repeat_units.yearly
      help_text += " on every #{day}-#{month}(DD-MM) at #{hour}:#{minute} hours"
      help_text += " repeating for every #{repeat_num} year(s)."
    when gon.repeat_units.monthly
      help_text += " on every #{day}(DD) at #{hour}:#{minute} hours"
      help_text += " repeating for every #{_formatNumber(repeat_num)} month of every year."
    when gon.repeat_units.daily
      help_text += " at every #{hour}:#{minute} hours"
      help_text += " repeating for every #{_formatNumber(repeat_num)} day of every month."
    when gon.repeat_units.hourly
      help_text += " at every #{minute} minute"
      help_text += " repeating for every #{_formatNumber(repeat_num)} hour of every day."
    when gon.repeat_units.minutes
      help_text += " repeating for every #{_formatNumber(repeat_num)} minute of every hour."
  $('#helpText').html(help_text)

_handleRepeatUnitChange = (event) ->
  year_dropdown = $('#fixedYear')
  month_dropdown = $('#fixedMonth')
  day_dropdown = $('#fixedDay')
  hour_dropdown = $('#fixedHour')
  minute_dropdown = $('#fixedMinute')
  repeat_num_div = $('#repeatNum')
  selected_unit = repeat_num_div.data('selected-unit')
  selected_num = repeat_num_div.data('selected-number')
  min_limit = 1
  max_limit = 0
  should_update_dropdown = true
  steps = 1
  switch parseInt($(@).val())
    when gon.repeat_units.none
      should_update_dropdown = false
      year_dropdown.prop('disabled', false)
      month_dropdown.prop('disabled', false)
      day_dropdown.prop('disabled', false)
      hour_dropdown.prop('disabled', false)
      minute_dropdown.prop('disabled', false)
    when gon.repeat_units.yearly
      max_limit = 5
      year_dropdown.prop('disabled', true)
      month_dropdown.prop('disabled', false)
      day_dropdown.prop('disabled', false)
      hour_dropdown.prop('disabled', false)
      minute_dropdown.prop('disabled', false)
    when gon.repeat_units.monthly
      max_limit = 11
      year_dropdown.prop('disabled', true)
      month_dropdown.prop('disabled', true)
      day_dropdown.prop('disabled', false)
      hour_dropdown.prop('disabled', false)
      minute_dropdown.prop('disabled', false)
    when gon.repeat_units.daily
      max_limit = 30
      year_dropdown.prop('disabled', true)
      month_dropdown.prop('disabled', true)
      day_dropdown.prop('disabled', true)
      hour_dropdown.prop('disabled', false)
      minute_dropdown.prop('disabled', false)
    when gon.repeat_units.hourly
      max_limit = 23
      year_dropdown.prop('disabled', true)
      month_dropdown.prop('disabled', true)
      day_dropdown.prop('disabled', true)
      hour_dropdown.prop('disabled', true)
      minute_dropdown.prop('disabled', false)
    when gon.repeat_units.minutes
      min_limit = 5
      max_limit = 55
      steps = 5
      repeat_num_div.show()
      year_dropdown.prop('disabled', true)
      month_dropdown.prop('disabled', true)
      day_dropdown.prop('disabled', true)
      hour_dropdown.prop('disabled', true)
      minute_dropdown.prop('disabled', true)
  if should_update_dropdown
    repeat_num_dropdown = $('#scheduler_repeat_number')
    repeat_num_dropdown.empty()
    repeat_num_div.show()
    i = min_limit
    while i <= max_limit
      $('<option />')
        .attr('value', i)
        .html(i)
        .appendTo(repeat_num_dropdown);
      i += steps
    if selected_unit == parseInt($(@).val()) && selected_num != undefined
      repeat_num_dropdown.val(selected_num)
  else
    repeat_num_div.hide()
  _showHelpText()

_schedulerInit = ->
  fixed_datetime = $('#fixedDatetime').data('fixed-datetime')
  scheduler_repeat_unit = $('#scheduler_repeat_unit')
  if scheduler_repeat_unit.length > 0
    if $('#repeatNum').data('selected-unit') == gon.repeat_units.none
      scheduler_repeat_unit.val(gon.repeat_units.none)
    scheduler_repeat_unit.change(_handleRepeatUnitChange)
    scheduler_repeat_unit.change()
    $('#fixedYear, #fixedMonth, #fixedDay, #fixedHour, #fixedMinute, #repeatNum').change(
      (event) ->
        _showHelpText()
      )
    if fixed_datetime != undefined
      _loadFixedDateTime()
      _showHelpText()

$(document).ready(_schedulerInit)