# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson vala xdg

DESCRIPTION="Multiplication Puzzle emulates the multiplication game found in Emacs"
HOMEPAGE="https://gitlab.gnome.org/mterry/gmult/"
SRC_URI="https://gitlab.gnome.org/mterry/gmult/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+ CC-BY-SA-4.0 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" # only used for unnecessary .desktop/.po validation

RDEPEND="
	dev-libs/glib:2
	>=gui-libs/gtk-4.14:4[introspection]
	>=gui-libs/libadwaita-1.6:1[vala]
	media-libs/graphene
	virtual/libintl
	x11-libs/cairo
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	dev-util/blueprint-compiler
	sys-devel/gettext
"

DOCS=( NEWS.md README.md )

src_configure() {
	vala_setup
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
