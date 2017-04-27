#!/bin/sh

logger "[ACPI] button_mute"
amixer -q set Master toggle

