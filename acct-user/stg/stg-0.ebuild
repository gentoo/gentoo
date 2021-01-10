# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=352
ACCT_USER_GROUPS=( stg )
ACCT_USER_HOME="/var/lib/stargazer"
ACCT_USER_HOME_OWNER="stg:stg"

acct-user_add_deps
