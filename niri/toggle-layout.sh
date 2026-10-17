#!/bin/sh

case "$(niri msg keyboard-layouts)" in
    *"* 1 "*) exec niri msg action switch-layout 2 ;;
    *)        exec niri msg action switch-layout 1 ;;
esac
