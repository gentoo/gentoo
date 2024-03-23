# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for memcached_exporter"
ACCT_USER_ID=234
ACCT_USER_GROUPS=( memcached_exporter )

acct-user_add_deps
