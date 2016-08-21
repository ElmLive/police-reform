module Zipcode exposing (isValid)

import String
import Char


isValid : String -> Bool
isValid zipcode =
    if String.length zipcode /= 5 then
        False
    else if String.all Char.isDigit zipcode then
        True
    else
        False
