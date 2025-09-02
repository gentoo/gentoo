# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=550
ACCT_USER_GROUPS=( sing-box )
ACCT_USER_HOME="/var/lib/sing-box"

acct-user_add_deps
