# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 vala

DESCRIPTION="Spell checking widget for GTK"
HOMEPAGE="http://gtkspell.sourceforge.net/"
MY_P="${PN}3-${PV}"
SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="3/0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="+introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=app-text/enchant-1.1.6
	app-text/iso-codes
	dev-libs/glib:2
	x11-libs/gtk+:3[introspection?]
	>=x11-libs/pango-1.8.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.17
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable vala)
}
