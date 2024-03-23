# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for net-proxy/cntlm"

ACCT_USER_GROUPS=( "cntlm" )
ACCT_USER_ID="255"

acct-user_add_deps
