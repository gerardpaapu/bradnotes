module Encode exposing (..)

import Data exposing (..)
import Dict exposing (toList)
import Json.Encode exposing (..)


encodeJoke joke =
    object
        [ ( "id", string joke.id )
        , ( "title", string joke.title )
        , ( "text", string joke.text )
        , ( "tags", list (List.map string joke.tags) )
        , ( "time", int joke.createDate )
        ]


encodeModelData : ModelData -> Value
encodeModelData data =
    object
        [ ( "id", int data.id )
        , ( "jokes"
          , object
                (List.map
                    (\( k, v ) -> ( k, encodeJoke v ))
                    (toList data.jokes)
                )
          )
        ]
