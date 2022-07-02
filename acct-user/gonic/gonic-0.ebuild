# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for media-sound/gonic"
ACCT_USER_ID=526
ACCT_USER_GROUPS=( gonic )
ACCT_USER_HOME="/var/lib/gonic"

acct-user_add_deps
