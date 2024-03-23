# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for ceph"

ACCT_USER_ID=267
ACCT_USER_HOME=/var/lib/ceph
ACCT_USER_GROUPS=( ceph )

acct-user_add_deps
