# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'622C7C012254C186677469C50C0B590E80CA15A7:wietse:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by mail-mta/postfix"
HOMEPAGE="http://ftp.porcupine.org/mirrors/postfix-release/index.html"
SRC_URI="http://ftp.porcupine.org/mirrors/postfix-release/wietse.pgp"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
