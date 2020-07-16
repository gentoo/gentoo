# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the Syncthing relay server"
ACCT_USER_ID=496
ACCT_USER_HOME=/var/lib/strelaysrv
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( strelaysrv )

acct-user_add_deps
