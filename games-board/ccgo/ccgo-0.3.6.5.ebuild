# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils toolchain-funcs flag-o-matic games

DESCRIPTION="An IGS client written in C++"
HOMEPAGE="http://ccdw.org/~cjj/prog/ccgo/"
SRC_URI="http://ccdw.org/~cjj/prog/ccgo/src/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

RDEPEND=">=dev-cpp/gtkmm-2.4:2.4
	>=dev-cpp/gconfmm-2.6
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e '/^Encoding/d' \
		-e '/^Categories/ { s/Application;//; s/$/GTK;/ }' \
		ccgo.desktop.in || die
	sed -i \
		-e '/^localedir/s/=.*/=@localedir@/' \
		-e '/^appicondir/s:=.*:=/usr/share/pixmaps:' \
		-e '/^desktopdir/s:=.*:=/usr/share/applications:' \
		Makefile.am || die
	# cargo cult from bug #569528
	append-cxxflags -std=c++11 -fpermissive
	find . -name '*.hh' -exec sed -i -e '/sigc++\/object.h/d' {} +
	find . -name '*.cc' -exec sed -i -e 's/(bind(/(sigc::bind(/' {} +
	epatch "${FILESDIR}"/${P}-gcc4.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--localedir=/usr/share/locale \
		$(use_enable nls)
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default
	prepgamesdirs
}
