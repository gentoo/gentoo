# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for games-strategy/wesnoth"
ACCT_USER_ID=419
ACCT_USER_GROUPS=( wesnoth )
ACCT_USER_SHELL="/bin/bash"

acct-user_add_deps
