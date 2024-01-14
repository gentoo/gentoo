# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for apt-cacher-ng"
ACCT_USER_ID=319
ACCT_USER_GROUPS=( apt-cacher-ng )

acct-user_add_deps
