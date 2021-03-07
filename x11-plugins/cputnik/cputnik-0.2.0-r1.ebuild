# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="cputnik is a simple cpu monitor dockapp"
HOMEPAGE="https://www.dockapps.net/cputnik"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${P}/src

PATCHES=( "${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
	)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin cputnik
	dodoc ../{AUTHORS,NEWS,README}
}
