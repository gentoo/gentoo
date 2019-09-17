# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the UniFi Controller"

ACCT_USER_GROUPS=( "unifi" )
ACCT_USER_HOME="/var/lib/unifi"
ACCT_USER_HOME_OWNER="unifi:unifi"
ACCT_USER_ID="113"

acct-user_add_deps
