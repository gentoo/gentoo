# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for the SpamAssassin daemon"

ACCT_USER_ID=337
ACCT_USER_GROUPS=( spamd )
# The spamd daemon runs as this user. Use a real home directory so
# that it can hold SA configuration.
ACCT_USER_HOME="/home/spamd"

acct-user_add_deps
