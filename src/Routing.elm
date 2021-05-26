module Routing exposing (..)

import Url exposing (Url)
import Url.Builder as Builder
import Url.Parser as U


type Route
    = RouteHome
    | RouteSettings
    | RouteNotFound


parseLocation : Url -> Route
parseLocation url =
    url
        |> U.parse matchers
        |> Maybe.withDefault RouteNotFound


matchers : U.Parser (Route -> a) a
matchers =
    U.oneOf
        [ U.map RouteHome U.top
        , U.map RouteSettings (U.s "settings")
        , U.map RouteSettings (U.s "404")
        ]


pathFromRoute : Route -> String
pathFromRoute route =
    case route of
        RouteHome ->
            Builder.absolute [] []

        RouteSettings ->
            Builder.absolute [ "settings" ] []

        RouteNotFound ->
            Builder.absolute [ "404" ] []
