#!/bin/sh
ESDL_ROOT="/usr/lib/erlang/lib/esdl"
WINGS_ROOT="/usr/lib/erlang/lib/wings"
exec erl -smp disable -noshell -pa $ESDL_ROOT/ebin $WINGS_ROOT/ebin -run wings_start start_halt
