# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the Spectrum messaging transport"

ACCT_USER_GROUPS=( "spectrum" )
ACCT_USER_HOME="/var/lib/spectrum2"
ACCT_USER_ID="486"

acct-user_add_deps
