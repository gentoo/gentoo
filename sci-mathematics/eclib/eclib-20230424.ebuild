# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Programs for elliptic curves defined over the rational numbers"
HOMEPAGE="https://github.com/JohnCremona/eclib"
SRC_URI="https://github.com/JohnCremona/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0/10"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="boost flint minimal test"
RESTRICT="!test? ( test )"

RDEPEND="sci-mathematics/pari:=
	dev-libs/ntl:=
	boost? ( dev-libs/boost:= )
	flint? ( sci-mathematics/flint:= )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(usex minimal --disable-allprogs "" "" "") \
		$(use_with boost) \
		$(use_with flint)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
