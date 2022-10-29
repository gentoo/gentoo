# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )
VALA_MIN_API_VERSION="0.54"

inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2+"
SLOT="0"
IUSE="telepathy"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv ~sparc ~x86"

VALA_DEPEND="
	$(vala_depend)
	>=dev-libs/gobject-introspection-1.54
	dev-libs/folks[vala(+)]
	net-libs/gnome-online-accounts[vala]
	gnome-extra/evolution-data-server[gtk,vala]
	>=dev-libs/libportal-0.6:=[vala]
	telepathy? ( net-libs/telepathy-glib[vala] )
	>=gui-libs/libhandy-1.1.0:1[vala]
"
RDEPEND="
	>=gnome-extra/evolution-data-server-3.30:=[gnome-online-accounts]
	>=dev-libs/folks-0.14.0:=[eds,telepathy?]
	>=dev-libs/glib-2.58:2
	>=dev-libs/libgee-0.10:0.8
	net-libs/gnome-online-accounts:=
	>=gui-libs/gtk-4.6:4
	gui-libs/libadwaita:1
	telepathy? ( >=net-libs/telepathy-glib-0.22 )
	>=gui-libs/libhandy-1.0.0:1
	>=dev-libs/libportal-0.6:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	${VALA_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dcamera=true # Ignored
		$(meson_use telepathy)
		-Dmanpage=true
		-Ddocs=false
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
