# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the Postfix postlift helper"
ACCT_USER_ID=564
ACCT_USER_GROUPS=( postdrop )

acct-user_add_deps
