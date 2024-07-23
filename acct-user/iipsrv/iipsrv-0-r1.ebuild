# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for iipsrv"

ACCT_USER_ID="536"
ACCT_USER_GROUPS=( "iipsrv" )

acct-user_add_deps
