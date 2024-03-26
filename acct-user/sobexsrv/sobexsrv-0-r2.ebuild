# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for sobexsrv: a secure OBEX server"
ACCT_USER_ID=387
ACCT_USER_GROUPS=( ${PN} )
ACCT_USER_HOME="/var/spool/sobexsrv"

acct-user_add_deps
