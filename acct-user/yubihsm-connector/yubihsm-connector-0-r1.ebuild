# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the yubihsm-connector service"
ACCT_USER_ID=528
ACCT_USER_GROUPS=( yubihsm-connector )

acct-user_add_deps
