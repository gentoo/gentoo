# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for dev-db/cockroach"

ACCT_USER_ID=110
ACCT_USER_GROUPS=( cockroach )
ACCT_USER_HOME=/var/lib/cockroach
ACCT_USER_SHELL=/bin/sh

acct-user_add_deps
