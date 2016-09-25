#!/bin/bash

# fswatch *.elm | xargs -n1 elm-make --output form.js Form.elm
fswatch *.elm | xargs -n1 elm-make --output LandingPage.js LandingPage.elm
