# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="shared storage lock manager"
ACCT_USER_ID=340
ACCT_USER_HOME=/dev/null
ACCT_USER_GROUPS=( ${PN} disk )

acct-user_add_deps
