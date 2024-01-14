# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for upmpdcli"
ACCT_USER_ID=372
ACCT_USER_GROUPS=( upmpdcli )

acct-user_add_deps
