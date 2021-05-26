module Model exposing (..)

import Browser
import Home
import Settings
import Url exposing (Url)


type Msg
    = URLRequest Browser.UrlRequest
    | URLChange Url
    | PageMsg PageMsg


type Page
    = PageHome Home.Model
    | PageSettings Settings.Model
    | PageNotFound


type PageMsg
    = HomeMsg Home.Msg
    | SettingsMsg Settings.Msg
