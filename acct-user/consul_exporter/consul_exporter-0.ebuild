# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for consul_exporter"
ACCT_USER_ID=278
ACCT_USER_GROUPS=( consul_exporter )

acct-user_add_deps
