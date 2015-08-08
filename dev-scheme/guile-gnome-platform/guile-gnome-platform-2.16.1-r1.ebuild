# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils eutils multilib

DESCRIPTION="Guile Scheme code that wraps the GNOME developer platform"
HOMEPAGE="http://www.gnu.org/software/guile-gnome/"
SRC_URI="http://ftp.gnu.org/pub/gnu/guile-gnome/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

RDEPEND="
	dev-libs/atk
	dev-libs/g-wrap
	dev-libs/glib:2
	dev-scheme/guile:12
	dev-scheme/guile-cairo
	dev-scheme/guile-lib
	gnome-base/gconf:2
	gnome-base/gnome-vfs:2
	gnome-base/libbonobo
	gnome-base/libglade:2.0
	gnome-base/libgnomecanvas
	gnome-base/libgnomeui
	gnome-base/orbit:2
	x11-libs/gtk+:2
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

#needs guile with networking
RESTRICT=test

MAKEOPTS+=" -j1"

src_prepare() {
	PATCHES=(
		"${FILESDIR}/${PV}-conflicting-types.patch"
		"${FILESDIR}/${PV}-gcc45.patch"
		"${FILESDIR}/${PV}-gdk-color.patch"
		"${FILESDIR}/${PV}-glib-single-include.patch"
		)
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-Werror
		)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile \
		guilegnomedir=/usr/share/guile/site \
		guilegnomelibdir=/usr/$(get_libdir)
}

src_install() {
	autotools-utils_src_install \
		guilegnomedir=/usr/share/guile/site \
		guilegnomelibdir=/usr/$(get_libdir)
}
