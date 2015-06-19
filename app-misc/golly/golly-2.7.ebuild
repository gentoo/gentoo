# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/golly/golly-2.7.ebuild,v 1.1 2015/06/09 17:38:24 xmw Exp $

EAPI=5
WX_GTK_VER=2.8
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 gnome2-utils wxwidgets

DESCRIPTION="simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}[X]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-src
ECONF_SOURCE=gui-wx/configure

src_configure() {
	econf --with-perl-shlib="libperl.so"
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
