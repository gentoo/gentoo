# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Port from an old amiga game"
HOMEPAGE="http://methane.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-games/clanlib:2.3[opengl,mikmod]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	# From Fedora
	"${FILESDIR}"/${P}-gcc5.patch
	"${FILESDIR}"/${P}-fullscreen.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share:" \
		sources/target.cpp || die

	tc-export CXX PKG_CONFIG

	# fix weird parallel make issue wrt #450422
	mkdir build || die
}

src_install() {
	dobin methane

	insinto /usr/share/${PN}
	doins resources/*

	newicon docs/puff.gif ${PN}.gif
	make_desktop_entry ${PN} "Super Methane Brothers" /usr/share/pixmaps/${PN}.gif
	HTML_DOCS="docs/*" dodoc authors.txt history.txt readme.txt
}
