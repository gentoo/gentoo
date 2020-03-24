# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

KEYWORDS="~amd64 ~x86"

DESCRIPTION="User for OpenBGPD"
# BGP port 179
ACCT_USER_ID=179
ACCT_USER_GROUPS=( _bgpd )
ACCT_USER_HOME=/var/empty

acct-user_add_deps
