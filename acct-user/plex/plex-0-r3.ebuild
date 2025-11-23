# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Plex Media Server user"
ACCT_USER_ID=103
ACCT_USER_HOME=/var/lib/plexmediaserver
ACCT_USER_GROUPS=( plex video )

acct-user_add_deps
