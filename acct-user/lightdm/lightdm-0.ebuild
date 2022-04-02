# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for x11-misc/lightdm"

ACCT_USER_GROUPS=( "lightdm" "video" )
ACCT_USER_HOME="/var/lib/lightdm"
ACCT_USER_ID="134"

acct-user_add_deps
