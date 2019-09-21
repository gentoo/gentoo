# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_USE_DEPEND="vapigen"
inherit vala meson gnome2-utils xdg-utils

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
	$(vala_depend)
"

src_prepare() {
	xdg_environment_reset
	vala_src_prepare
	default
}

src_configure() {
	meson_src_configure \
		-Dwith-docs=true
}

src_install() {
	meson_src_install
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
