module UStruct.USet exposing (Struct, empty, fromList, contains, add, remove)

import List as L


type Struct a
    = Struct_ (List a)


empty : Struct a
empty =
    Struct_ []


reduceListToSet : List a -> Struct a -> Struct a
reduceListToSet list set =
    case list of
        [] ->
            set

        x :: xs ->
            reduceListToSet xs <| add x set


fromList : List a -> Struct a
fromList list =
    reduceListToSet list empty


contains : a -> Struct a -> Bool
contains targetElement (Struct_ innerList) =
    L.member targetElement innerList


add : a -> Struct a -> Struct a
add newElement (Struct_ innerList) =
    let
        alreadyHasElement =
            L.member newElement innerList
    in
        if alreadyHasElement then
            Struct_ innerList
        else
            Struct_ (newElement :: innerList)


remove : a -> Struct a -> Struct a
remove targetElement (Struct_ innerList) =
    Struct_ (L.filter (\e -> e /= targetElement) innerList)
