module Data.Project exposing (Concept(..), Language(..), Project, conceptToString, fromJson)

-- Project type!

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias Project =
    { name : String

    -- , imgLink : String
    , blurb : String
    , link : String
    , githubLink : String
    , year : Int
    , language : Language
    , concepts : Maybe (List Concept)
    }


type Language
    = Elm
    | Python


type Concept
    = Parsing
    | APIs
    | SPA
    | PWA
    | DataStructures
    | Firebase


conceptToString : Concept -> String
conceptToString concept =
    case concept of
        Parsing ->
            "Parsing"

        APIs ->
            "APIs"

        SPA ->
            "SPA"

        PWA ->
            "PWA"

        DataStructures ->
            "Data Structures"

        Firebase ->
            "Firebase"



-- PARSER


fromJson : String -> Result Decode.Error (List Project)
fromJson =
    Decode.decodeString (Decode.list decodeSingle)


decodeSingle : Decoder Project
decodeSingle =
    Decode.succeed Project
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "blurb" Decode.string
        |> Pipeline.required "link" Decode.string
        |> Pipeline.required "githubLink" Decode.string
        |> Pipeline.required "year" Decode.int
        |> Pipeline.required "language" languageDecoder
        |> Pipeline.optional "concepts" (Decode.map Just conceptsDecoder) Nothing


languageDecoder : Decoder Language
languageDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "Elm" ->
                        Decode.succeed Elm

                    "Python" ->
                        Decode.succeed Python

                    other ->
                        Decode.fail <| "Unknown language " ++ other
            )


conceptsDecoder : Decoder (List Concept)
conceptsDecoder =
    let
        singleDecoder =
            Decode.string
                |> Decode.andThen
                    (\str ->
                        case str of
                            "Parsing" ->
                                Decode.succeed Parsing

                            "APIs" ->
                                Decode.succeed APIs

                            "SPA" ->
                                Decode.succeed SPA

                            "PWA" ->
                                Decode.succeed PWA

                            "DataStructures" ->
                                Decode.succeed DataStructures

                            "Firebase" ->
                                Decode.succeed Firebase

                            other ->
                                Decode.fail <| "Unknown concept " ++ other
                    )
    in
    Decode.list singleDecoder