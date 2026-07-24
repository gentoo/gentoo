# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

ACCT_USER_ID=561
ACCT_USER_GROUPS=( systemd-imds )

acct-user_add_deps
