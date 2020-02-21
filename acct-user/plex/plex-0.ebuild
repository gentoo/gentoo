# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Plex Media Server user"
ACCT_USER_ID=103
ACCT_USER_HOME=/var/lib/plexmediaserver
ACCT_USER_GROUPS=( plex video )

acct-user_add_deps
