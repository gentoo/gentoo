# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for capturing network traffic"
ACCT_USER_ID=377
ACCT_USER_GROUPS=( pcap )

acct-user_add_deps
