# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the system-wide net-p2p/syncthing server"
ACCT_USER_ID=499
ACCT_USER_HOME=/var/lib/syncthing
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( syncthing )

acct-user_add_deps
