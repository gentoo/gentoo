# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2-utils xdg-utils

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapps/"
LICENSE="GPL-3"

SRC_URI="https://github.com/linuxmint/xapps/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"

SLOT="0"
IUSE="introspection static-libs"

RDEPEND="
	>=dev-libs/glib-2.37.3:2
	dev-libs/gobject-introspection:0=
	gnome-base/libgnomekbd
	gnome-base/gnome-common
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22.0:2[introspection?]
	>=x11-libs/gtk+-3.3.16:3[introspection?]
	x11-libs/libxkbfile
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/gtk-doc
	dev-util/gtk-doc-am
"

src_prepare() {
	xdg_environment_reset
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-gtk-doc \
		--enable-gtk-doc-html \
		$(use_enable introspection) \
		$(use_enable static-libs static)
}

src_install() {
	default
	rm -rf "${ED%/}"/usr/bin || die

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
