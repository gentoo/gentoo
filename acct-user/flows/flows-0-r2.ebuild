# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="uid for net-analyzer/flow-tools"
ACCT_USER_ID=384
ACCT_USER_HOME=/var/lib/flows
ACCT_USER_GROUPS=( flows )

acct-user_add_deps
