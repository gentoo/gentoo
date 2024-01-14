# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="mysqld_exporter User"
ACCT_USER_ID=308
ACCT_USER_HOME=/var/lib/mysqld_exporter
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( mysqld_exporter )

acct-user_add_deps
