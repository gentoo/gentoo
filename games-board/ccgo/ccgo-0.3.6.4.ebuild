# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ccgo/ccgo-0.3.6.4.ebuild,v 1.7 2014/10/10 15:20:30 ago Exp $

EAPI=5
inherit autotools toolchain-funcs games

DESCRIPTION="An IGS client written in C++"
HOMEPAGE="http://ccdw.org/~cjj/prog/ccgo/"
SRC_URI="http://ccdw.org/~cjj/prog/ccgo/src/${P}.tar.gz"

LICENSE="GPL-3"
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
