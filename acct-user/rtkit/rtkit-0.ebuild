# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the Realtime Policy and Watchdog Daemon"
ACCT_USER_ID=133
ACCT_USER_GROUPS=( rtkit )

acct-user_add_deps
