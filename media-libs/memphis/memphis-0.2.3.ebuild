# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/memphis/memphis-0.2.3.ebuild,v 1.24 2015/03/29 09:49:27 jlec Exp $

EAPI=4

WANT_AUTOMAKE=1.11

AUTOTOOLS_AUTORECONF=true
VALA_MIN_API_VERSION=0.12

inherit autotools-utils vala

DESCRIPTION="A map-rendering application and a library for OpenStreetMap"
HOMEPAGE="http://trac.openstreetmap.ch/trac/memphis/"
SRC_URI="http://wenner.ch/files/public/mirror/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0.2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="debug doc +introspection vala static-libs"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	x11-libs/cairo
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )"

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=( "${FILESDIR}"/${P}-link_gobject.patch )

src_prepare() {
	unset VALAC
	use vala && vala_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable doc gtk-doc)
		$(use_enable introspection)
		$(use_enable vala)
	)
	CFLAGS="${CFLAGS}" \
		autotools-utils_src_configure
}
