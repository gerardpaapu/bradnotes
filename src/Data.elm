module Data exposing (..)

import Dict exposing (Dict)


type alias Joke =
    { id : String
    , title : String
    , text : String
    , tags : List String
    , time : Maybe Int
    , createDate : Int
    }


type alias SetList =
    { id : String
    , title : String
    , description : String
    , jokes : List Int
    }


type alias ModelData =
    { id :
        Int
        -- when I create a new item, use this as the id, but increment it
    , jokes : Dict String Joke
    , setlists : Dict String SetList
    }
