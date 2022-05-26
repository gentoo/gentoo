# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for the headless LibreOffice server"

ACCT_USER_GROUPS=( "libreoffice" )
ACCT_USER_HOME="/var/lib/libreoffice"
ACCT_USER_ID="512"

acct-user_add_deps
