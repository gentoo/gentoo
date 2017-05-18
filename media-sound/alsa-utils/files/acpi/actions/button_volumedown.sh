#!/bin/sh

inc=1dB
logger "[ACPI] button_volumedown"
amixer -q set Master $inc-

