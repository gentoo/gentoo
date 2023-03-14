# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala

DESCRIPTION="Deferred Execution library for GNOME and GTK"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libdex"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"

IUSE="gtk-doc +introspection sysprof test vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.68:2
	>=sys-libs/liburing-0.7:=
	introspection? ( dev-libs/gobject-introspection:= )
	sysprof? ( dev-util/sysprof-capture:4 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	vala? ( $(vala_depend) )
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
"

src_prepare() {
	default
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc docs)
		-Dexamples=false
		$(meson_use vala vapi)
		$(meson_feature introspection)
		-Dsysprof=false
		$(meson_use test tests)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN}-1 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
