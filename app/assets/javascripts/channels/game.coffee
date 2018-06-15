# App.game = App.cable.subscriptions.create "GameChannel",
App.game = App.cable.subscriptions.create { channel: "GameChannel", game_uuid: window.location.href.split(/[//]+/).pop() },
  connected: ->
    # Called when the subscription is ready for use on the server
    document.getElementById("state").innerText = "Waiting for an opponent to join..."

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    switch data.action
      when "game_start"
        document.getElementById("state").innerText = data.turn
        document.getElementById("player_piece").innerText = data.msg
      when "select_square"
        # console.log('App.game received select_square data = ' + data + ', selection = ' + data.selection)
        document.getElementById(data.selection).innerText = data.piece
        if data.game_won.length > 0
          document.getElementById("state").innerText = data.game_won
        else
          document.getElementById("state").innerText = data.turn

  select_square: (square_number) ->
    # console.log('App.game select_square')
    @perform 'select_square', data: square_number
