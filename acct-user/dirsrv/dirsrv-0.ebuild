# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
KEYWORDS="~amd64 ~x86"

inherit acct-user

DESCRIPTION="Dirsrv user"
ACCT_USER_ID=360
ACCT_USER_HOME=/var/empty
ACCT_USER_HOME_OWNER=root:root
ACCT_USER_GROUPS=( dirsrv )

acct-user_add_deps
