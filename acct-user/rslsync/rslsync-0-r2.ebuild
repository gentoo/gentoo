# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-p2p/resilio-sync"

ACCT_USER_GROUPS=( "rslsync" )
ACCT_USER_HOME="/var/lib/resilio-sync"
ACCT_USER_HOME_PERMS="0700"
ACCT_USER_ID="175"

acct-user_add_deps
