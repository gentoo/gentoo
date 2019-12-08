# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MAX_API_VERSION="0.44"
inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Calculator"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-linux ~x86-linux"

# gtksourceview vapi definitions in dev-lang/vala itself are too old, and newer vala removes them
# altogether, thus we need them installed by gtksourceview[vala]
RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=x11-libs/gtk+-3.19.3:3
	>=x11-libs/gtksourceview-4.0.2:4
	>=net-libs/libsoup-2.42:2.4
	dev-libs/libxml2:2
	dev-libs/mpc:=
	dev-libs/mpfr:0=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	net-libs/libsoup:2.4[vala]
	x11-libs/gtksourceview:4[vala]
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
