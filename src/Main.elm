module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Navigation
import Element exposing (..)
import Home
import Model exposing (Msg(..), Page(..), PageMsg(..))
import Routing exposing (Route(..))
import Settings
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = URLRequest
        , onUrlChange = URLChange
        }


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init () url key =
    ( { page = PageHome Home.init
      , key = key
      , route = Routing.parseLocation url
      }
    , Cmd.none
    )


type alias Model =
    { page : Page
    , key : Navigation.Key
    , route : Route
    }



---- View ----


view : Model -> Document Msg
view model =
    { title = "Test app"
    , body = [ Element.layout [] (viewPage model) ]
    }


viewPage : Model -> Element Msg
viewPage model =
    let
        ( pageTitle, pageView ) =
            case model.page of
                PageHome homeModel ->
                    ( "Home"
                    , Home.view homeModel
                        |> Element.map (HomeMsg >> PageMsg)
                    )

                PageSettings settingsModel ->
                    ( "Settings"
                    , Settings.view settingsModel
                        |> Element.map (SettingsMsg >> PageMsg)
                    )

                PageNotFound ->
                    ( "Not Found", none )
    in
    column [ spacing 40, padding 40 ]
        [ text ("Page: " ++ pageTitle)
        , pageView
        ]



--- Update ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        URLRequest urlRequest ->
            case urlRequest of
                Browser.Internal location ->
                    ( model
                    , Routing.parseLocation location
                        |> Routing.pathFromRoute
                        |> Navigation.pushUrl model.key
                    )

                Browser.External href ->
                    ( model, Navigation.load href )

        URLChange location ->
            let
                newRoute =
                    Routing.parseLocation location

                newPage =
                    setPageFromRoute newRoute
            in
            ( { model
                | route = newRoute
                , page = newPage
              }
            , Cmd.none
            )

        PageMsg pageMsg ->
            handlePageMsg pageMsg model


handlePageMsg : PageMsg -> Model -> ( Model, Cmd Msg )
handlePageMsg pageMsg model =
    case ( pageMsg, model.page ) of
        ( HomeMsg homeMsg, PageHome homeModel ) ->
            let
                ( newHomeModel, homeCmd ) =
                    Home.update homeMsg homeModel
            in
            ( { model | page = PageHome newHomeModel }
            , homeCmd |> Cmd.map (HomeMsg >> PageMsg)
            )

        ( SettingsMsg settingsMsg, PageSettings settingsModel ) ->
            let
                ( newSettingsModel, settingsCmd ) =
                    Settings.update settingsMsg settingsModel
            in
            ( { model | page = PageSettings newSettingsModel }
            , settingsCmd |> Cmd.map (SettingsMsg >> PageMsg)
            )

        ( _, _ ) ->
            ( model, Cmd.none )



--- Routes and Pages ---


setPageFromRoute : Route -> Page
setPageFromRoute route =
    case route of
        RouteHome ->
            PageHome Home.init

        RouteSettings ->
            PageSettings Settings.init

        RouteNotFound ->
            PageNotFound
