module Modules.Projects.View exposing (view)

import Browser.Navigation as Navigation
import Element exposing (Device, DeviceClass(..), Element, Orientation(..))
import Element.Font as Font
import Modules.Projects.Group as Group
import Modules.Projects.List as ProjectList exposing (projects)
import Modules.Projects.Types exposing (Language(..), Model, Msg(..), Project)
import SharedState exposing (SharedState)
import UiFramework.Padding



-- VIEW --


view : Model -> SharedState -> Element Msg
view model sharedState =
    Element.column
        [ Element.spacing 50 ]
        [ introText
        , elmDivider
        , Group.view model sharedState (ProjectList.filter Elm projects)
        ]
        |> UiFramework.Padding.responsive sharedState.device



-- the little blurb with lots of vertical padding lelll


introText : Element Msg
introText =
    Element.paragraph
        [ Element.paddingXY 0 30 ]
        [ Element.text "Welcome to my projects page! I am in the process or organizing them so they're just all grouped up as elm projects lol." ]


elmDivider : Element Msg
elmDivider =
    divider
        { logoImage = "src/img/elm_logo.png"
        , logoDescription = "Sexy elm logo. You should click it!"
        , link = "elm-lang.org"
        , text = "Created with Elm"
        }



-- Dividers are there to separate the projects into multiple segments. It introduces a new section (e.g. a new language)


divider : DividerOptions -> Element Msg
divider options =
    let
        logo opt =
            Element.newTabLink
                [ Element.height Element.fill
                , Element.paddingXY 40 0
                ]
                { url = opt.link
                , label =
                    Element.image
                        [ Element.height (Element.px 60)
                        , Element.centerY
                        ]
                        { src = opt.logoImage
                        , description = opt.logoDescription
                        }
                }
    in
    Element.column
        [ Element.paddingXY 0 15
        , Element.width Element.fill
        , Element.spacing 15
        ]
        [ Element.el [ Element.centerX ] <| logo options
        , Element.paragraph
            [ Font.center
            , Font.size 30
            ]
            [ Element.text options.text ]
        ]


type alias DividerOptions =
    { logoImage : String
    , logoDescription : String
    , link : String
    , text : String
    }
