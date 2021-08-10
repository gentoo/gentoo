# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for lighttpd"
ACCT_USER_ID=302
ACCT_USER_GROUPS=( lighttpd )

acct-user_add_deps
