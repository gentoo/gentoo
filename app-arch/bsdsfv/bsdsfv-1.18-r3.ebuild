# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="all-in-one SFV checksum utility"
HOMEPAGE="https://bsdsfv.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~m68k ppc ~s390 ~sparc x86"

PATCHES=( "${FILESDIR}"/${P}-64bit.patch )

src_compile() {
	emake STRIP=":" CC="$(tc-getCC)"
}

src_install() {
	dobin bsdsfv
	dodoc README MANUAL
}
