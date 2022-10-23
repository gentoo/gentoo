# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml(+)"

inherit gnome.org meson-multilib python-single-r1 vala xdg

DESCRIPTION="An object-oriented framework for creating UPnP devs and control points"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP https://gitlab.gnome.org/GNOME/gupnp"

LICENSE="LGPL-2+ GPL-2+" # gupnp-binding-tool is GPL-2+
SLOT="1.6/1.6-0" # <API version>-<soname>
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="connman gtk-doc +introspection networkmanager +vala"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( connman networkmanager )
	gtk-doc? ( introspection )
"

# prefix: uuid dependency can be adapted to non-linux platforms
RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.69:2[${MULTILIB_USEDEP}]
	>=net-libs/gssdp-1.5.2:1.6=[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.99.0:3.0[introspection?,${MULTILIB_USEDEP}]
	>=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gi-docgen-2021.1 )
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	virtual/pkgconfig
	!connman? ( !networkmanager? ( kernel_linux? ( sys-kernel/linux-headers ) ) )
	vala? ( $(vala_depend)
		>=net-libs/gssdp-1.5.2:1.6[vala]
		net-libs/libsoup:3.0[vala]
	)
"

src_prepare() {
	default
	use vala && vala_setup
}

multilib_src_configure() {
	local backend=system
	use kernel_linux && backend=linux
	use connman && backend=connman
	use networkmanager && backend=network-manager

	local emesonargs=(
		-Dcontext_manager=${backend}
		$(meson_native_use_bool introspection)
		$(meson_native_use_bool vala vapi)
		$(meson_native_use_bool gtk-doc gtk_doc)
		-Dexamples=false
	)
	meson_src_configure
}

multilib_src_install_all() {
	python_fix_shebang "${ED}"/usr/bin/gupnp-binding-tool-1.6
	if use gtk-doc ; then
		mkdir "${ED}"/usr/share/gtk-doc || die
		mv "${ED}"/usr/share/doc/gupnp-1.6/{reference,html} || die
		mv "${ED}"/usr/share/{doc,gtk-doc}/gupnp-1.6 || die
	fi
}
