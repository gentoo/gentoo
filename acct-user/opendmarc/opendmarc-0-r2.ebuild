# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for mail-filter/opendmarc"

ACCT_USER_ID=244
ACCT_USER_GROUPS=( opendmarc )

ACCT_USER_HOME="/var/lib/opendmarc"
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
