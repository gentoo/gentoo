# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	BCA43417C3B485DD128EC6D4B7B3B788A8D3785C:mysql:ubuntu
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign MySQL releases"
HOMEPAGE="https://dev.mysql.com/doc/refman/8.4/en/checking-gpg-signature.html"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc64 ~riscv ~s390 ~sparc ~x86"
