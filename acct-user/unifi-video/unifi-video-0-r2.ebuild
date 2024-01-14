# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for Unifi Video"
ACCT_USER_ID=348
ACCT_USER_GROUPS=( unifi-video )

acct-user_add_deps
