# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-p2p/freenet"

KEYWORDS="~amd64 ~x86"

ACCT_USER_ID=105
ACCT_USER_GROUPS=( ${PN} )
ACCT_USER_HOME=/var/freenet
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
