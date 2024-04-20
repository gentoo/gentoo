# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Group for Sauerbraten (FOSS game engine (Cube 2))"
ACCT_USER_ID=286
ACCT_USER_GROUPS=( sauerbraten )

acct-user_add_deps
