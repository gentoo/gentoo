# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop

DESCRIPTION="Port from an old amiga game"
HOMEPAGE="http://methane.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-games/clanlib:2.3[opengl,mikmod]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default

	eapply "${FILESDIR}"/${P}-gentoo.patch

	# From Fedora
	eapply "${FILESDIR}"/${P}-gcc5.patch
	eapply "${FILESDIR}"/${P}-fullscreen.patch

	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share:" \
		sources/target.cpp || die

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
