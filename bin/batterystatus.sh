#!/bin/bash

bateria="$(acpi | grep -o '[[:digit:]]*%')"
notify-send "$bateria"
