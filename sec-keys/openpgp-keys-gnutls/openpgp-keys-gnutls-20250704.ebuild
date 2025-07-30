# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	'E987AB7F7E89667776D05B3BB0E9DD20B29F1432:alexander.sosedken:manual'
	# GnuTLS website has expired key for daiki
	'462225C3B46F34879FC8496CD605848ED7E69871:daiki:openpgp,ubuntu'
	'1CB27DBC98614B2D5841646D08302DB6A2670428:tim.ruehsen:manual'
	'5D46CB0F763405A7053556F47A75A648B3F9220C:zfridrich:manual'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used by GnuTLS"
HOMEPAGE="https://www.gnutls.org/download.html"
SRC_URI+="
	https://gnutls.org/gnutls-release-keyring.gpg -> ${P}-release-keyring.gpg
"

KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"
