# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson-multilib xdg

DESCRIPTION="Library to handle UPnP IGD port mapping for GUPnP"
HOMEPAGE="http://gupnp.org https://gitlab.gnome.org/GNOME/gupnp-igd"

LICENSE="LGPL-2.1+"
SLOT="0/1.2" # pkg-config file links in gupnp API, so some consumers of gupnp-igd need to be relinked for it
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.38.0:2[${MULTILIB_USEDEP}]
	>=net-libs/gssdp-1.2:0=[${MULTILIB_USEDEP}]
	>=net-libs/gupnp-1.2:0=[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.10 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2 )
"

# The only existing test is broken
#RESTRICT="test"

src_prepare() {
	xdg_src_prepare
	default
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool introspection)
		$(meson_native_use_bool gtk-doc gtk_doc)
	)
	meson_src_configure
}
