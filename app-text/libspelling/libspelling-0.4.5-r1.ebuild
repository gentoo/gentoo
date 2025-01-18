# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala

DESCRIPTION="A GNOME library for spellchecking"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libspelling"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="1"
KEYWORDS="~amd64 ~riscv"
IUSE="gtk-doc sysprof vala"

RDEPEND="
	dev-libs/glib:2
	>=gui-libs/gtk-4.8:4
	>=gui-libs/gtksourceview-5.6:5
	app-text/enchant:2
	dev-libs/icu:=
"
DEPEND="${RDEPEND}
	sysprof? ( dev-util/sysprof-capture:4 )
	vala? (
		$(vala_depend)
		>=gui-libs/gtksourceview-5.6:5[vala]
	)
"
BDEPEND="
	dev-libs/gobject-introspection
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
"

src_prepare() {
	use vala && vala_setup
	default
}

src_configure() {
	local emesonargs=(
		-Denchant=enabled
		-Dinstall-static=false
		$(meson_use gtk-doc docs)
		$(meson_use sysprof)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN}-${SLOT} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
