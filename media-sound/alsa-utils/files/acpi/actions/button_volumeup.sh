#!/bin/sh

inc=1dB
logger "[ACPI] button_volumeup"
amixer -q set Master $inc+

