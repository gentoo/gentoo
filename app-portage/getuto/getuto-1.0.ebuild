# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SRC_URI="https://github.com/akhuettel/${PN}/archive/refs/tags/${P}.tar.gz"
DESCRIPTION="Stand-alone gentoo install trust anchor generation tool"
HOMEPAGE="
	https://github.com/akhuettel/getuto/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	app-crypt/gnupg
	sec-keys/openpgp-keys-gentoo-release
"

S=${WORKDIR}/${PN}-${P}

src_install() {
	dobin getuto
}
