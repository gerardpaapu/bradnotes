module Decode exposing (decodeModelData)

import Data exposing (..)
import Json.Decode exposing (..)


jokeDecoder =
    object6 Joke
        ("id" := string)
        ("title" := string)
        ("text" := string)
        ("tags" := list string)
        (maybe <| "time" := int)
        ("createDate" := int)


setlistDecoder =
    object4 SetList
        ("id" := string)
        ("title" := string)
        ("description" := string)
        ("jokes" := list int)


modelDataDecoder =
    object3 ModelData
        ("id" := int)
        ("jokes" := dict jokeDecoder)
        ("setlists" := dict setlistDecoder)


decodeModelData : String -> Result String ModelData
decodeModelData =
    decodeString modelDataDecoder
