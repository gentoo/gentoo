# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="SABnzbd program user"

ACCT_USER_ID=397
ACCT_USER_HOME="/var/lib/${PN}"
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( sabnzbd )

acct-user_add_deps
