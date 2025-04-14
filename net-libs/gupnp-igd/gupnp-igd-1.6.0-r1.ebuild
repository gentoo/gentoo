# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson-multilib xdg

DESCRIPTION="Library to handle UPnP IGD port mapping for GUPnP"
HOMEPAGE="http://gupnp.org https://gitlab.gnome.org/GNOME/gupnp-igd"

LICENSE="LGPL-2.1+"
SLOT="1.6/1.6-0" # <API version>-<soname>
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc +introspection"

# The only existing test is broken
RESTRICT="test"

DEPEND="
	>=dev-libs/glib-2.70.0:2[${MULTILIB_USEDEP}]
	>=net-libs/gssdp-1.6:1.6=[${MULTILIB_USEDEP}]
	>=net-libs/gupnp-1.6:1.6=[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.10 )
"
RDEPEND="${DEPEND}
	gtk-doc? ( !net-libs/gupnp-igd:0[gtk-doc] )
"
BDEPEND="
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2
	)
"

src_prepare() {
	default
	xdg_environment_reset
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool introspection)
		$(meson_native_use_bool gtk-doc gtk_doc)
	)
	meson_src_configure
}
