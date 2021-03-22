# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for unbound-telemetry"
ACCT_USER_ID=279
ACCT_USER_GROUPS=( unbound-telemetry )

acct-user_add_deps
