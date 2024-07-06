# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for media-sound/owntone"
ACCT_USER_ID=541
ACCT_USER_GROUPS=( audio )
ACCT_USER_HOME="/var/lib/${PN}"

acct-user_add_deps
