# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="xml(+)"

inherit gnome.org meson-multilib python-single-r1 vala xdg

DESCRIPTION="An object-oriented framework for creating UPnP devs and control points"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP https://gitlab.gnome.org/GNOME/gupnp"

LICENSE="LGPL-2+ GPL-2+" # gupnp-binding-tool is GPL-2+
SLOT="0/1.2-0" # <API version>-<soname>
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~sparc x86"

IUSE="connman gtk-doc +introspection networkmanager vala"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( connman networkmanager )
"

# prefix: uuid dependency can be adapted to non-linux platforms
RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.66:2[${MULTILIB_USEDEP}]
	>=net-libs/gssdp-1.3.0:0=[introspection?,${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.48.0:2.4[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	>=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.14
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.2 )
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	virtual/pkgconfig
	!connman? ( !networkmanager? ( kernel_linux? ( sys-kernel/linux-headers ) ) )
	vala? ( $(vala_depend)
		>=net-libs/gssdp-1.3.0:0[vala]
		net-libs/libsoup:2.4[vala]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.3-meson-1.2.0-fix.patch
)

src_prepare() {
	use introspection && vala_src_prepare
	xdg_src_prepare

	# This makes sense for upstream but not for us downstream, bug #906124.
	sed -i -e '/-Werror=deprecated-declarations/d' meson.build || die
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
	python_fix_shebang "${ED}"/usr/bin/gupnp-binding-tool-1.2
}
