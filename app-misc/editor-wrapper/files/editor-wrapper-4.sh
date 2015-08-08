#!/bin/sh
# Copyright 2009-2011 Gentoo Foundation
# Distributed under the terms of the MIT/X11 license

# Wrapper script, executes ${@VAR@} with arguments $@

if [ -z "${@VAR@}" ]; then
    # Try to get @VAR@ from system profile
    @VAR@=$(. /etc/profile >/dev/null 2>&1; echo "${@VAR@}")
fi

if [ -z "${@VAR@}" ]; then
    echo "$0: The @VAR@ variable must be set" >&2
    exit 1
fi

exec ${@VAR@} "$@"
