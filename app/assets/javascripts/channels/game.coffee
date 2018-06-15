# App.game = App.cable.subscriptions.create "GameChannel",
App.game = App.cable.subscriptions.create { channel: "GameChannel", game_uuid: window.location.href.split(/[//]+/).pop() },
  connected: ->
    # Called when the subscription is ready for use on the server
    # $('#state').html("Waiting player 2 to join...")
    document.getElementById("state").innerText = "Waiting for player 2 to join..."

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
