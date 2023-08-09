# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Server user for media-sound/snapcast"

ACCT_USER_GROUPS=( "snapserver" )
ACCT_USER_HOME_PERMS=0770
ACCT_USER_ID=374

acct-user_add_deps
