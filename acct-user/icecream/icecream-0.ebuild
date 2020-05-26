# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION='User for sys-devel/icecream'

ACCT_USER_HOME=/var/cache/icecream
ACCT_USER_ID=397
ACCT_USER_GROUPS=( icecream )

acct-user_add_deps
