# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the app-backup/burp server"
ACCT_USER_ID=498
ACCT_USER_GROUPS=( burp )

acct-user_add_deps
