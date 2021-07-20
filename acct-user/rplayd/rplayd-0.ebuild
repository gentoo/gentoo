# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for media-sound/rplay"

ACCT_USER_GROUPS=( "rplayd" )
ACCT_USER_ID="161"

acct-user_add_deps
