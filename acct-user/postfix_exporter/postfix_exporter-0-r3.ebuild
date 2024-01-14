# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for postfix_exporter"
ACCT_USER_ID=356
ACCT_USER_GROUPS=( postfix_exporter )
ACCT_USER_HOME=/var/lib/postfix_exporter

acct-user_add_deps
