# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop toolchain-funcs

DESCRIPTION="A Doom level (wad) editor"
HOMEPAGE="http://www.teaser.fr/~amajorel/yadex/"
SRC_URI="http://www.teaser.fr/~amajorel/yadex/${P}.tar.gz
	http://www.teaser.fr/~amajorel/yadex/logo_small.png -> ${PN}.png
	http://glbsp.sourceforge.net/yadex/Yadex_170_ALL.diff
	https://dev.gentoo.org/~pacho/${PN}/${P}-mrmeval-differential-patch.patch
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}
	games-fps/freedoom
"

src_prepare() {
	default

	eapply "${DISTDIR}"/Yadex_170_ALL.diff
	eapply "${DISTDIR}"/${P}-mrmeval-differential-patch.patch
	eapply "${FILESDIR}"/*.patch

	# Remove bundled boost
	rm -rf boost/
	# Force the patched file to be old, otherwise the compile fails
	touch -t 197010101010 "${S}"/src/wadlist.cc
	touch -t 197010101010 "${S}"/src/gfx.cc
}

src_configure() {
	tc-export CC CXX LD AR RANLIB
	# not an autoconf script
	./configure --prefix="/usr" || die "configure failed"
}

src_compile() {
	emake CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS} -std=gnu++03"
}

src_install() {
	dobin obj/0/yadex
	insinto "/usr/share/${PN}/${PV}"
	doins ygd/*
	doman doc/yadex.6
	HTML_DOCS="docsrc/" einstalldocs
	insinto /etc/yadex/${PV}
	doins yadex.cfg

	make_desktop_entry "yadex -i2 /usr/share/doom-data/freedoom/freedm.wad"
	doicon "${DISTDIR}"/${PN}.png
}
