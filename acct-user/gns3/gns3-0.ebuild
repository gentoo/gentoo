# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=522
ACCT_USER_HOME=/var/lib/gns3
ACCT_USER_GROUPS=( gns3 ubridge )

acct-user_add_deps
