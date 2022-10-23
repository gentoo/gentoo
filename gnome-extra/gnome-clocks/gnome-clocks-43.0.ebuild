# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Clocks application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Clocks https://gitlab.gnome.org/GNOME/gnome-clocks"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.68:2
	>=gui-libs/gtk-4.5:4
	>=media-libs/gsound-0.98
	>=dev-libs/libgweather-4.2.0:4=
	gnome-base/gnome-desktop:4=
	>=sci-geosciences/geocode-glib-1:2
	>=app-misc/geoclue-2.4:2.0
	>=gui-libs/libadwaita-1.2:1
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	>=dev-libs/libgweather-4.2.0:4[vala]
	media-libs/gsound[vala]
	gui-libs/libadwaita:1[vala]
"

DOCS=( AUTHORS.md CONTRIBUTING.md README.md )

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dprofile=default
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
