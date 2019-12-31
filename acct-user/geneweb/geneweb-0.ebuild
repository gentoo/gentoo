# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user id for geneweb daemon"

KEYWORDS="~amd64 ~x86"

ACCT_USER_ID=467
ACCT_USER_SHELL=/bin/bash
ACCT_USER_HOME=/var/lib/geneweb
ACCT_USER_GROUPS=( geneweb )

acct-user_add_deps
