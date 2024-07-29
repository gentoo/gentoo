# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the UniFi Controller"

ACCT_USER_GROUPS=( "unifi" )
ACCT_USER_HOME="/var/lib/unifi"
ACCT_USER_ID="113"

acct-user_add_deps
