# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-mail/fetchmail"
ACCT_USER_ID=124
ACCT_USER_GROUPS=( fetchmail )
ACCT_USER_HOME="/var/lib/fetchmail"
ACCT_USER_HOME_PERMS=0700

acct-user_add_deps
