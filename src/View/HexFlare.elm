module View.HexFlare exposing (view)

import Colours
import Element exposing (Element)
import Element.Background as Background
import Html
import Html.Attributes
import SharedState exposing (SharedState)


view : SharedState -> Element msg
view sharedState =
    Html.canvas
        [ Html.Attributes.id "hex" ]
        []
        |> Element.html
        |> Element.el
            [ Element.width <| Element.px sharedState.windowSize.width
            , Element.height <| Element.px sharedState.windowSize.height
            ]
