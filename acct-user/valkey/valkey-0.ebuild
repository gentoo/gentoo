# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Valkey program user"
ACCT_USER_ID=559
ACCT_USER_GROUPS=( valkey )
acct-user_add_deps
