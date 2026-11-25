# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="Programs for elliptic curves defined over the rational numbers"
HOMEPAGE="https://github.com/JohnCremona/eclib"
SRC_URI="https://github.com/JohnCremona/${PN}/releases/download/v${PV}/${P}.tar.bz2"

# COPYING is GPL-2 but the file headers say "or ... any later version"
# LGPL-2.1+ is for bundled GetOpt.cc
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/16"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="boost minimal test"
RESTRICT="!test? ( test )"

RDEPEND="sci-mathematics/pari:=
	dev-libs/ntl:=
	sci-mathematics/flint:=
	boost? ( dev-libs/boost:= )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-testfix.patch" )

src_configure() {
	econf \
		$(usex minimal --disable-allprogs "" "" "") \
		$(use_with boost)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
