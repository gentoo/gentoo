# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-analyzer/sguil-sensor"

ACCT_USER_GROUPS=( "sguil" )
ACCT_USER_HOME="/var/lib/sguil"
ACCT_USER_ID="165"

acct-user_add_deps
