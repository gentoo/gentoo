# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for rspamd - Rapid spam filtering system"
ACCT_USER_ID=237
ACCT_USER_GROUPS=( rspamd )

acct-user_add_deps
