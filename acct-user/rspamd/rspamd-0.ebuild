# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for rspamd - Rapid spam filtering system"
ACCT_USER_ID=237
ACCT_USER_GROUPS=( rspamd )

acct-user_add_deps
