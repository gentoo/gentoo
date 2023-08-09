# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for running PipeWire as a system-wide instance"
ACCT_USER_ID=509
ACCT_USER_GROUPS=( pipewire audio )
ACCT_USER_HOME=/dev/null

acct-user_add_deps
