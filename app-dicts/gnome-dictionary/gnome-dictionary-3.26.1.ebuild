# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Dictionary utility for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Dictionary"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="0" # does not provide a public libgdict-1.0.so anymore
IUSE="ipv6"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	>=dev-libs/glib-2.42:2
	>=x11-libs/gtk+-3.21.2:3
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gsettings-desktop-schemas
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use ipv6 use_ipv6)
		-Dbuild_man=true
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
