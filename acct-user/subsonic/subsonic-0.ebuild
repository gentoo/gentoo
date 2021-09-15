# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for media-sound/subsonic-bin"

ACCT_USER_GROUPS=( "subsonic" )
ACCT_USER_HOME="/var/lib/subsonic"
ACCT_USER_ID="126"

acct-user_add_deps
