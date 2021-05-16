# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for nginx-vts-exporter"
ACCT_USER_ID=354
ACCT_USER_GROUPS=( nginx-vts-exporter )

acct-user_add_deps
