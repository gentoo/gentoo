# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson multilib-minimal vala xdg

DESCRIPTION="GObject-based API for handling resource discovery and announcement over SSDP"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP"

LICENSE="LGPL-2+"
SLOT="0/1.2-0" # <API version>-<soname>
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~ppc ppc64 ~sparc x86"
IUSE="gtk-doc +introspection gtk vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.54:2[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.26.1:2.4[${MULTILIB_USEDEP},introspection?]
	gtk? ( >=x11-libs/gtk+-3.12:3 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( >=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.1.2 )
	virtual/pkgconfig
	vala? (
		$(vala_depend)
		net-libs/libsoup:2.4[vala]
	)
"

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

multilib_src_configure() {
	local emesonargs=(
		-Dgtk_doc=$(multilib_native_usex gtk-doc true false)
		-Dsniffer=$(multilib_native_usex gtk true false)
		-Dintrospection=$(multilib_native_usex introspection true false)
		-Dvapi=$(multilib_native_usex vala true false)
		-Dexamples=false
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
