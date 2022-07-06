# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for sonarr"
ACCT_USER_HOME=/var/lib/sonarr
ACCT_USER_ID=515
ACCT_USER_GROUPS=( sonarr )

acct-user_add_deps
