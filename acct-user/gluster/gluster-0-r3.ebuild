# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

# Needed for statedumps
# https://github.com/gluster/glusterfs/commit/0e50c4b3ea734456c14e2d7a578463999bd332c3

ACCT_USER_ID=416
ACCT_USER_GROUPS=( "${PN}" )

acct-user_add_deps
