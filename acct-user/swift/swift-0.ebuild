# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="USER for swift - Openstack object storage backend"
ACCT_USER_ID=449
ACCT_USER_GROUPS=( swift )

acct-user_add_deps
