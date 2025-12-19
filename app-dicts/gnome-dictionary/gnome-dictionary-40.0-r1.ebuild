# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic gnome.org gnome2-utils meson xdg

DESCRIPTION="Dictionary utility for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Dictionary"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="0" # does not provide a public libgdict-1.0.so anymore
IUSE=""
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"

DEPEND="
	>=dev-libs/glib-2.42:2
	>=x11-libs/gtk+-3.21.2:3
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-meson-0.61.patch
)

src_configure() {
	# Replicate what a release buildtype would set, as we use -Dbuildtype=plain
	append-cflags -DG_DISABLE_ASSERT -DG_DISABLE_CHECKS -DG_DISABLE_CAST_CHECKS

	local emesonargs=(
		-Duse_ipv6=true
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
