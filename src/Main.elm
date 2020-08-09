module Main exposing (..)

import Browser
import Data.Flags exposing (Flags, WindowSize)
import Element exposing (Element)
import Element.Font as Font
import Html exposing (Html)
import Util
import View.About as About
import View.Contact as Contact
import View.Home as Home
import View.Projects as Projects



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }



---- MODEL ----


type alias Model =
    { windowSize : WindowSize
    , about : About.Model
    , home : Home.Model
    , projects : Projects.Model
    , contact : Contact.Model
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { windowSize = flags.windowSize
      , about = About.init
      , home = Home.init flags
      , projects = Projects.init
      , contact = About.init
      }
    , Cmd.none
    )



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacing 48
        ]
        [ Home.view model.home
            |> Element.map HomeMsg
        , About.view model.about
            |> Element.map AboutMsg
        , Projects.view model.projects
            |> Element.map ProjectsMsg
        , Contact.view model.contact
            |> Element.map ContactMsg
        , footer
        ]
        |> Element.layout
            [ Font.family
                [ Font.typeface "Lato"
                , Font.sansSerif
                ]
            ]


footer : Element Msg
footer =
    Element.paragraph
        [ Element.padding 64
        , Font.center
        , Font.size 16
        ]
        [ Element.text "All code is open source and available on "
        , Util.link
            { label = "Github"
            , link = "https://github.com/joshuanianji/website"
            }
        ]



---- UPDATE ----


type Msg
    = HomeMsg Home.Msg
    | AboutMsg About.Msg
    | ProjectsMsg Projects.Msg
    | ContactMsg Contact.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HomeMsg homeMsg ->
            let
                ( newHomeModel, homeCmd ) =
                    Home.update homeMsg model.home
            in
            ( { model | home = newHomeModel }, Cmd.map HomeMsg homeCmd )

        AboutMsg aboutMsg ->
            let
                ( newAboutModel, aboutCmd ) =
                    About.update aboutMsg model.about
            in
            ( { model | about = newAboutModel }, Cmd.map AboutMsg aboutCmd )

        ProjectsMsg projectsMsg ->
            let
                ( newProjectsModel, projectsCmd ) =
                    Projects.update projectsMsg model.projects
            in
            ( { model | projects = newProjectsModel }, Cmd.map ProjectsMsg projectsCmd )

        ContactMsg contactMsg ->
            let
                ( newContactModel, contactCmd ) =
                    Contact.update contactMsg model.contact
            in
            ( { model | contact = newContactModel }, Cmd.map ContactMsg contactCmd )



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Home.subscriptions model.home
            |> Sub.map HomeMsg
        , About.subscriptions model.about
            |> Sub.map AboutMsg
        , Projects.subscriptions model.projects
            |> Sub.map ProjectsMsg
        , Contact.subscriptions model.contact
            |> Sub.map ContactMsg
        ]
