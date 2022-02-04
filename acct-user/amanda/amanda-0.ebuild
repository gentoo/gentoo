# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=362
ACCT_USER_GROUPS=( "${PN}" )
ACCT_USER_HOME=/var/spool/amanda

acct-user_add_deps
