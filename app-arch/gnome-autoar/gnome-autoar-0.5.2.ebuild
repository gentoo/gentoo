# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VALA_USE_DEPEND="vapigen"

inherit gnome.org meson vala

DESCRIPTION="Automatic archives creating and extracting library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-autoar"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +introspection test vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-arch/libarchive-3.4.0:=
	>=dev-libs/glib-2.35.6:2
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/meson-1.8.0
	virtual/pkgconfig
	dev-util/glib-utils
	gtk-doc? (
		dev-util/gi-docgen
		app-text/docbook-xml-dtd:4.3
	)
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_setup
	default
}

src_configure() {
	local emesonargs=(
		$(meson_feature introspection)
		$(meson_use vala vapi)
		$(meson_use test tests)
		$(meson_use gtk-doc docs)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
