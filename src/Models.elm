module Models exposing (..)

import Time exposing (Time)

import Msgs exposing (Msg)
import Constants

type alias Model =
  { timer : Time
  , elapsed : Time
  , counting : Bool
  , currentMode : Msgs.Modes
  , animate : Int
  }

initialModel : Model
initialModel =
  { timer = Constants.codeTime
  , elapsed = 0
  , counting = False
  , currentMode = Msgs.Work
  , animate = 1
  }

init : ( Model, Cmd Msg)
init =
  ( initialModel, Cmd.none )
