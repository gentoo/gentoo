# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-nds/389-ds-base"
ACCT_USER_ID=346
ACCT_USER_GROUPS=( dirsrv )

acct-user_add_deps
