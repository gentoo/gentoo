# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Client user for media-sound/snapcast"

ACCT_USER_GROUPS=( "audio" )
ACCT_USER_HOME_OWNER="snapserver"
ACCT_USER_HOME_PERMS=0770
ACCT_USER_ID=373

acct-user_add_deps
