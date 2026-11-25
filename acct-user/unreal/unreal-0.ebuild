# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit acct-user

DESCRIPTION="User for the Unreal and Unreal Tournament games"

ACCT_USER_HOME=/var/lib/unreal
ACCT_USER_GROUPS=( unreal )
ACCT_USER_ID=563

acct-user_add_deps
