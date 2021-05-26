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

        TheDefaultCase foo ->
            ( { model | foo = foo.wat.hereIsAnElmException }
            , Cmd.none
            )


view : Model -> Element msg
view model =
    -- This is important
    column [] []
