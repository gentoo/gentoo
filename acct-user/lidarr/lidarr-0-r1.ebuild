# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for lidarr"
ACCT_USER_HOME=/var/lib/lidarr
ACCT_USER_ID=530
ACCT_USER_GROUPS=( lidarr )

acct-user_add_deps
