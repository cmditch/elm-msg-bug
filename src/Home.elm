module Home exposing (..)

import Element exposing (..)
import Element.Border
import Element.Font
import Element.Input
import Html
import Html.Attributes
import Html.Events as Html
import Json.Decode as Decode


type alias Model =
    { input : String
    , focused : Bool
    }


init : Model
init =
    { input = ""
    , focused = False
    }


view : Model -> Element Msg
view model =
    column [ spacing 20 ]
        [ column
            [ Html.on "focusin" (Decode.succeed <| Focused True) |> htmlAttribute
            , Html.on "focusout" (Decode.succeed <| Focused False) |> htmlAttribute
            , Element.Border.width 3
            , if model.focused then
                Element.Border.color (rgba255 232 26 26 1)

              else
                Element.Border.color (rgba255 0 0 0 0)
            , padding 10
            , spacing 10
            ]
            [ Element.Input.text []
                { onChange = UpdateInput
                , text = model.input
                , placeholder =
                    Just
                        (Element.Input.placeholder
                            [ Element.Font.size 16 ]
                            (text "I change my parents focus")
                        )
                , label = Element.Input.labelHidden ""
                }
            ]
        , link
            [ Html.preventDefaultOn "mousedown"
                (Decode.succeed ( NoOp, True ))
                |> htmlAttribute
            , Element.Font.color (rgb255 26 115 232)
            ]
            { url = "/settings"
            , label = text "Go To Settings (preventDefaultOn mousedown)"
            }
        ]


type Msg
    = UpdateInput String
    | Focused Bool
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateInput str ->
            ( { model | input = str }, Cmd.none )

        Focused flag ->
            ( { model | focused = flag }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
