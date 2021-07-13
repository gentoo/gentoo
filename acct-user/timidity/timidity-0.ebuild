# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for media-sound/timidity++"

ACCT_USER_GROUPS=( "nobody" )
ACCT_USER_HOME="/var/lib/timidity"
ACCT_USER_HOME_PERMS="0700"
ACCT_USER_ID="306"

acct-user_add_deps
