# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://apps.gnome.org/Contacts/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+gnome-online-accounts"

VALA_DEPEND="
	$(vala_depend)
	>=dev-libs/gobject-introspection-1.82.0-r2
	dev-libs/folks[vala(+)]
	gnome-online-accounts? ( net-libs/gnome-online-accounts[vala] )
	gnome-extra/evolution-data-server[gtk,vala]
	>=dev-libs/libportal-0.7:=[gtk,vala]
"
RDEPEND="
	>=dev-libs/folks-0.14.0:=[eds]
	>=dev-libs/libgee-0.10:0.8=
	>=dev-libs/glib-2.64:2
	>=gui-libs/gtk-4.15.3:4
	>=gui-libs/libadwaita-1.8_alpha:1
	>=gnome-extra/evolution-data-server-3.42:=[gnome-online-accounts?]
	>=dev-libs/libportal-0.7:=
	>=media-libs/gstreamer-1
	>=media-gfx/qrencode-4.1.1:=
	gnome-online-accounts? ( net-libs/gnome-online-accounts:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	${VALA_DEPEND}
	dev-util/blueprint-compiler
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
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
		-Dmanpage=true
		-Ddocs=false
		$(meson_use gnome-online-accounts goa)
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
