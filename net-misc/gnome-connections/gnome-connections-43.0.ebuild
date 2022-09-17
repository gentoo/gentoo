# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )
inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="A remote desktop client for the GNOME desktop environment"
HOMEPAGE="https://gitlab.gnome.org/GNOME/connections"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/gobject-introspection
	>=dev-libs/glib-2.50:2
	>=x11-libs/gtk+-3.22:3[introspection]
	>=net-libs/gtk-vnc-0.4.4[pulseaudio,vala]
	>=gui-libs/libhandy-1.6.0:1[vala]
	>=dev-libs/libxml2-2.7.8
	app-crypt/libsecret[vala]

	>=net-misc/freerdp-2.0.0:0=
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-libs/glib
	dev-util/glib-utils
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig

	test? (
		dev-libs/appstream-glib
		dev-util/desktop-file-utils
	)
"

src_prepare() {
	default
	vala_setup
}

src_configure() {
	local emesonargs=(
		-Dprofile=default
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
