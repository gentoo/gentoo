# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the DERP service of net-vpn/tailscale"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/derper
ACCT_USER_GROUPS=( derper )

acct-user_add_deps
