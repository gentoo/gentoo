# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for sys-auth/microsoft-identity-broker"
ACCT_USER_ID=539
ACCT_USER_GROUPS=( microsoft-identity-broker )

acct-user_add_deps
