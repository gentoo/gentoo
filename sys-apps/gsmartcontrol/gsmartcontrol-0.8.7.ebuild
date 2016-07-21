# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit flag-o-matic gnome2-utils

DESCRIPTION="Hard disk drive health inspection tool"
HOMEPAGE="http://gsmartcontrol.sourceforge.net/home/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 ) Boost-1.0 BSD Unlicense ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

COMMON_DEPEND="dev-cpp/gtkmm:2.4
	dev-libs/libpcre
	sys-apps/smartmontools"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xmessage"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	test? ( dev-util/gtk-builder-convert )"

DOCS="TODO" # See 'dist_doc_DATA' value in Makefile.am

src_prepare() {
	append-cxxflags -std=c++11
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use test tests)
}

src_install() {
	default
	rm -f "${ED}"/usr/share/doc/${PF}/LICENSE_* || die
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
