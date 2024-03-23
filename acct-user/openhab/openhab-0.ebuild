# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=537
ACCT_USER_GROUPS=( ${PN} dialout )
ACCT_USER_HOME=/var/lib/${PN}
ACCT_USER_HOME_PERMS=0750

acct-user_add_deps
