# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for kafka"

ACCT_USER_ID=425
ACCT_USER_HOME=/var/lib/kafka
ACCT_USER_SHELL=/bin/sh
ACCT_USER_GROUPS=( kafka )

acct-user_add_deps
