# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for mail-filter/milter-regex"

ACCT_USER_ID=438
ACCT_USER_GROUPS=( milter-regex )

acct-user_add_deps
