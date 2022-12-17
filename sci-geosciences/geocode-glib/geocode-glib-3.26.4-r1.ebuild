# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson xdg

DESCRIPTION="GLib helper library for geocoding services"
HOMEPAGE="https://gitlab.gnome.org/GNOME/geocode-glib"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="gtk-doc +introspection test"
RESTRICT="!test? ( test )"

# Needs to depend on geocode-glib-3.26.4:2 because only slot 2 has some svg
# files that we patch out here to avoid file collisions.
RDEPEND="
	>=dev-libs/glib-2.44:2
	>=dev-libs/json-glib-0.99.2[introspection?]
	>=net-libs/libsoup-2.42:2.4[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )

	>=sci-geosciences/geocode-glib-3.26.4-r201:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.13
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-r200-do-not-install-icons.patch
)

src_configure() {
	local emesonargs=(
		-Denable-installed-tests=false
		$(meson_use introspection enable-introspection)
		$(meson_use gtk-doc enable-gtk-doc)
		-Dsoup2=true
	)
	meson_src_configure
}
