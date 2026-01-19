# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	67A2AB4F41F9972C21F6BF667B89011BCAE1CFEA:vsftpd:manual
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used for vsftpd releases"
HOMEPAGE="https://security.appspot.com/vsftpd.html"
SRC_URI="https://security.appspot.com/downloads/scarybeasts_gmail_pubkey.gpg -> ${P}-scarybeasts_gmail_pubkey.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
