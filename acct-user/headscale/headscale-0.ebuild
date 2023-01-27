# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Headscale Server hosting user"

ACCT_USER_ID=514
ACCT_USER_HOME_PERMS=750
ACCT_USER_GROUPS=( headscale )
ACCT_USER_HOME=/var/lib/headscale

acct-user_add_deps
