$(document).ready ->
  $(document).on 'click', '#load_more', (e) ->
    e.preventDefault()
    page = $(this).data('page')
    $.ajax
      url: '/'
      data: page: page
      beforeSend: showLoading
      complete: hideLoading
      dataType: 'script'

showLoading = ->
  $('#loading-modal').modal('show')

hideLoading = ->
  $('#loading-modal').modal('hide')
