# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="shellinabox user"
ACCT_USER_ID=139
ACCT_USER_GROUPS=( shellinaboxd )

acct-user_add_deps
