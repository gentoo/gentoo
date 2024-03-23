# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="shared storage lock manager"
ACCT_USER_ID=340
ACCT_USER_HOME=/dev/null
ACCT_USER_GROUPS=( ${PN} disk )

acct-user_add_deps
