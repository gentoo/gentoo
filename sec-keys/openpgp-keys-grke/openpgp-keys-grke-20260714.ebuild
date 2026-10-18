# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	28386B441AB24FD49766FBF73A68D2214C21357C:grke:manual,ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP key used by Graham Keeling"
HOMEPAGE="https://burp.grke.org/download.html"
SRC_URI+=" https://burp.grke.org/downloads/grke.gpg -> ${P}-grke.gpg"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
