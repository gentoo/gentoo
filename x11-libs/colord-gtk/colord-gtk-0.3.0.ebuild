# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit meson vala

DESCRIPTION="GTK support library for colord"
HOMEPAGE="https://www.freedesktop.org/software/colord/"
SRC_URI="https://www.freedesktop.org/software/colord/releases/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0/1" # subslot = libcolord-gtk soname version
KEYWORDS="amd64 ~arm arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

IUSE="doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=dev-libs/glib-2.28:2
	>=x11-misc/colord-0.1.27:=[introspection?,vala?]
	x11-libs/gtk+:3[introspection?]
	>=gui-libs/gtk-4.4:4[introspection?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/libxslt
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1.9
	)
	app-text/docbook-xsl-ns-stylesheets
	introspection? ( >=dev-libs/gobject-introspection-0.9.8 )
	vala? ( $(vala_depend) )
"

RESTRICT="test" # Tests need a display device with a default color profile set

src_prepare() {
	use vala && vala_src_prepare
	default
}

src_configure() {
	local -a emesonargs=(
		-Dgtk4=true
		-Dgtk3=true
		-Dgtk2=false
		$(meson_use introspection)
		$(meson_use vala vapi)
		-Dtests=false
		-Dman=true
		$(meson_use doc docs)
	)
	meson_src_configure
}
