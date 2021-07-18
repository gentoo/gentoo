# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for net-misc/rabbitmq-server"

ACCT_USER_GROUPS=( "rabbitmq" )
ACCT_USER_HOME="/var/lib/rabbitmq"
ACCT_USER_HOME_PERMS="0750"
ACCT_USER_ID="121"

acct-user_add_deps
