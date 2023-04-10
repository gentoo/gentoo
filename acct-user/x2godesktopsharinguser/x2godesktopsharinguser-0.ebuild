# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-misc/x2godesktopsharing"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( x2godesktopsharing )
ACCT_USER_HOME="/var/lib/x2godesktopsharing"

acct-user_add_deps
