# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the slurm - Highly Scalable Resource Manager"
ACCT_USER_ID=400
ACCT_USER_HOME=/var/lib/slurm
ACCT_USER_HOME_PERMS=0770
ACCT_USER_GROUPS=( slurm )

acct-user_add_deps
