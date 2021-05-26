module Settings exposing (..)

import Element exposing (..)


type alias Model =
    { foo : Int }


init : Model
init =
    { foo = 1 }


type Msg
    = NoOp
    | TheDefaultCase { wat : { hereIsAnElmException : Int } }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        TheDefaultCase constructorValue ->
            let
                _ =
                    Debug.log "" constructorValue.wat.hereIsAnElmException
            in
            ( model
            , Cmd.none
            )


view : Model -> Element msg
view model =
    -- This is important
    column [] []
