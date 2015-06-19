# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gelemental/gelemental-1.2.0.ebuild,v 1.8 2012/07/31 06:47:17 jlec Exp $

EAPI=4

inherit autotools-utils fdo-mime gnome2-utils eutils

DESCRIPTION="Periodic table viewer that provides detailed information on the chemical elements"
HOMEPAGE="http://freecode.com/projects/gelemental/"
SRC_URI="http://www.kdau.com/files/${P}.tar.bz2"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc static-libs"

RDEPEND="
	dev-cpp/gtkmm:2.4
	dev-cpp/glibmm:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	doc? ( app-doc/doxygen )"

PATCHES=(
		"${FILESDIR}"/${P}-gcc4.3.patch
		"${FILESDIR}"/${P}-glib-2.32.patch
		"${FILESDIR}"/${P}-doxygen.patch )

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=( $(use_enable doc api-docs) )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install apidir="/usr/share/doc/${PF}/html"
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
