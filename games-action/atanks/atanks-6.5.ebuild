# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Worms and Scorched Earth-like game"
HOMEPAGE="https://atanks.sourceforge.io/"
SRC_URI="mirror://sourceforge/atanks/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/allegro:0[X]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-6.4-fix-build-system.patch
)

src_compile() {
	tc-export CXX

	emake INSTALLDIR="${EPREFIX}/usr/share/${PN}"
}

src_install() {
	dobin ${PN}

	dodoc Changelog README TODO

	insinto /usr/share/${PN}
	doins -r button misc missile sound stock tank tankgun text title unicode.dat *.txt

	doicon ${PN}.png
	make_desktop_entry atanks "Atomic Tanks"
}
