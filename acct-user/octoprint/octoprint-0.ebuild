# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for OctoPrint"

ACCT_USER_ID=368
ACCT_USER_HOME=/var/lib/octoprint
ACCT_USER_HOME_OWNER=octoprint:octoprint
ACCT_USER_GROUPS=( octoprint video )

acct-user_add_deps
