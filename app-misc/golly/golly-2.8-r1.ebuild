# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER=3.0
PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic python-single-r1 gnome2-utils wxwidgets

DESCRIPTION="simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="dev-lang/perl
	virtual/opengl
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}"

S=${WORKDIR}/${P}-src
ECONF_SOURCE=gui-wx/configure

pkg_setup() {
	setup-wxwidgets
}

src_configure() {
	append-libs -lGL -ldl
	econf \
		--with-perl-shlib="libperl.so" \
		--with-wxshared
}

src_install() {
	emake docdir= DESTDIR="${D}" install
	dodoc docs/ReadMe.html
	newicon --size 32 gui-wx/icons/appicon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Golly" ${PN} "Science"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
