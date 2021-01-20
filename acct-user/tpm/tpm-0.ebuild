# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=347
ACCT_USER_GROUPS=( "${PN}" )
ACCT_USER_HOME=/var/lib/${PN}

acct-user_add_deps
