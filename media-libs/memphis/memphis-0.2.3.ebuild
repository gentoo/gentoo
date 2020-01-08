# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WANT_AUTOMAKE=1.11

inherit autotools vala

DESCRIPTION="A map-rendering application and a library for OpenStreetMap"
HOMEPAGE="http://trac.openstreetmap.ch/trac/memphis/"
SRC_URI="http://wenner.ch/files/public/mirror/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0.2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="debug doc +introspection vala"

RDEPEND="
	dev-libs/expat:=
	dev-libs/glib:2
	x11-libs/cairo:=
	introspection? ( dev-libs/gobject-introspection )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )"

PATCHES=( "${FILESDIR}"/${P}-link_gobject.patch )

src_prepare() {
	default
	eautoreconf

	unset VALAC
	use vala && vala_src_prepare
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable vala)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
