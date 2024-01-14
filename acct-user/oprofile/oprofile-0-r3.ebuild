# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for dev-util/oprofile JIT code processing"
ACCT_USER_ID=492
ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
