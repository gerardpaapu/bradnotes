port module Main exposing (..)

import Data exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Task
import Time exposing (now)


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { data : ModelData
    , uiState : UiState
    }


type alias Id =
    String


type UiState
    = Searching SearchOpts
    | EditingJoke Id
    | EditingSetList Id


type alias SearchOpts =
    { text : Maybe String
    , tags : Maybe (List String)
    , maxLength : Maybe Int
    , minLength : Maybe Int
    }


initSearchOpts : SearchOpts
initSearchOpts =
    { text = Nothing
    , tags = Nothing
    , maxLength = Nothing
    , minLength = Nothing
    }


init : ( Model, Cmd Msg )
init =
    let
        data =
            { id = 0
            , setlists = Dict.empty
            , jokes = Dict.empty
            }

        model =
            { data = data
            , uiState = Searching initSearchOpts
            }
    in
        ( model, Cmd.none )



-- PORTS


type Msg
    = EditJoke String
    | CreateJoke
    | AddJoke Int
    | UpdateJoke String String
    | GoToSearch
    | Ignore


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditJoke idx ->
            ( { model | uiState = EditingJoke idx }, Cmd.none )

        GoToSearch ->
            ( { model | uiState = Searching initSearchOpts }, Cmd.none )

        CreateJoke ->
            ( model, createJoke )

        AddJoke now ->
            let
                data =
                    model.data

                id =
                    data.id + 1

                key =
                    toString id

                data' =
                    { data
                        | jokes = Dict.insert key (initJoke key now) data.jokes
                        , id = id
                    }
            in
                ( { model | data = data' }, Cmd.none )

        UpdateJoke idx text ->
            let
                jokes =
                    Dict.update
                        idx
                        (Maybe.map (\j -> { j | text = text }))
                        model.data.jokes

                data =
                    model.data

                data' =
                    { data | jokes = jokes }
            in
                ( { model | data = data' }, Cmd.none )

        Ignore ->
            ( model, Cmd.none )



-- VIEW


viewJokeTime : Joke -> Html c
viewJokeTime joke =
    case joke.time of
        Just t ->
            span []
                [ text (toString t ++ "m") ]

        Nothing ->
            text ""


viewJoke : ( String, Joke ) -> Html Msg
viewJoke ( idx, joke ) =
    li []
        [ h3 [] [ text joke.title ]
        , Markdown.toHtml [] joke.text
        , button [ onClick (EditJoke idx) ] [ text "edit" ]
        , viewJokeTime joke
        ]


view : Model -> Html Msg
view { uiState, data } =
    case uiState of
        Searching opts ->
            div []
                [ div []
                    [ button
                        [ onClick CreateJoke ]
                        [ text "+ new joke" ]
                    ]
                , ul []
                    (List.map
                        viewJoke
                        (Dict.toList data.jokes)
                    )
                ]

        EditingJoke id ->
            case (Dict.get id data.jokes) of
                Nothing ->
                    -- How did this happen
                    -- Just create a new joke
                    -- maybe with an error message
                    p [] [ text "oops" ]

                Just joke ->
                    div [ class "poop" ]
                        [ h2 [] [ text joke.title ]
                        , textarea
                            [ onInput (UpdateJoke id) ]
                            [ text joke.text ]
                        , button
                            [ onClick GoToSearch ]
                            [ text "Return to List" ]
                        ]

        _ ->
            text ""


createJoke : Cmd Msg
createJoke =
    Task.perform (\_ -> Ignore) AddJoke (Task.map floor Time.now)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
