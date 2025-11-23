# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for nginx-vts-exporter"
ACCT_USER_ID=354
ACCT_USER_GROUPS=( nginx-vts-exporter )

acct-user_add_deps
