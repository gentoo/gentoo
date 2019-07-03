# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the Syncthing discovery server"
ACCT_USER_ID=497
ACCT_USER_HOME=/var/lib/stdiscosrv
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( stdiscosrv )

acct-user_add_deps
