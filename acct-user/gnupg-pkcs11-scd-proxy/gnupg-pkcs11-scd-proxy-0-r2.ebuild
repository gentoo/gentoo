# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for app-crypt/gnupg-pkcs11-scd"

ACCT_USER_GROUPS=( "gnupg-pkcs11-scd-proxy" "gnupg-pkcs11" )
ACCT_USER_ID="281"

acct-user_add_deps
