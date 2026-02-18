# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for kde-plasma/plasma-login-manager"

ACCT_USER_GROUPS=( "plasmalogin" "video" )
ACCT_USER_HOME="/var/lib/plasmalogin"
ACCT_USER_ID=557

acct-user_add_deps
