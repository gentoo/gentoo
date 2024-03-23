# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-group

# TCP port 179, but 179 is already used by acct-group/_bgpd
ACCT_GROUP_ID=180
