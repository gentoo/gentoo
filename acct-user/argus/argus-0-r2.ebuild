# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="uid for net-analyzer/argus"
ACCT_USER_ID=383
ACCT_USER_HOME=/var/lib/argus
ACCT_USER_GROUPS=( argus )

acct-user_add_deps
