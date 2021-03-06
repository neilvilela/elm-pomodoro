module Update exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model, initialModel)
import Constants
import Time exposing (second)
import Notification

timesUpNotification : Models.Notification
timesUpNotification =
  { title = "Time's up!"
  , body = "You finish your Pomodoro."
  , icon = Maybe.Just "https://frontendmasters.com/assets/Elm.png"
  }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Msgs.Tick time ->
      if model.counting then
        let
          elapsed = model.elapsed + second
          newModel = { model | elapsed = elapsed }

          timeInSecondsMod = floor (Time.inSeconds elapsed) % 120
          timeRemaining = model.timer - elapsed
        in
          if timeRemaining == 0 then
            if timeInSecondsMod == 0 then
              ( { newModel | counting = False, animate = 0 }, Notification.notify (Models.encodeNotification <| timesUpNotification) )
            else
              ( { newModel | counting = False, animate = 1 }, Notification.notify (Models.encodeNotification <| timesUpNotification) )
          else
            ( { newModel | animate = 1 }, Cmd.none )
      else
        ( model, Cmd.none )

    Msgs.StartWork ->
      ( startTimer Constants.codeTime Msgs.Work, Cmd.none )

    Msgs.StartCoffee ->
      ( startTimer Constants.coffeeTime Msgs.Coffee, Cmd.none )

    Msgs.StartSocial ->
      ( startTimer Constants.socialTime Msgs.Social, Cmd.none )

    Msgs.Play ->
      ( { model | counting = True }, Cmd.none )

    Msgs.Pause ->
      ( { model | counting = False }, Cmd.none)

    Msgs.RequestPermission ->
      ( model, Notification.requestNotificationPermission True )

startTimer : Float -> Msgs.Modes -> Model
startTimer timer mode =
  { initialModel
  | timer = timer
  , counting = True
  , currentMode = mode
  , animate = 0
  }
