# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the postgrey mail daemon"
ACCT_USER_ID=360
ACCT_USER_GROUPS=( postgrey )

acct-user_add_deps
