# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=102
ACCT_USER_GROUPS=( polkitd )
ACCT_USER_HOME=/var/lib/polkit-1

acct-user_add_deps
