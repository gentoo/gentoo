# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for app-admin/vaultwarden"

ACCT_USER_ID=549
ACCT_USER_GROUPS=( "${PN}" )

acct-user_add_deps
