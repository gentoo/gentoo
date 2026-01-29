# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	9D13D9426A0814B3373CF5E3D8A8243577A7859F:leiningen:openpgp
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign Leiningen packages"
HOMEPAGE="https://codeberg.org/leiningen/leiningen/releases"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ~ppc64 ~riscv ~s390 ~sparc ~x86"
