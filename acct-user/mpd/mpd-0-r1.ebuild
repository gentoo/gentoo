# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for music player daemon (mpd)"
ACCT_USER_ID=45
ACCT_USER_HOME=/var/lib/mpd
ACCT_USER_GROUPS=( audio )

acct-user_add_deps
