# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2 vala

MY_P="${PN}3-${PV}"

DESCRIPTION="Spell checking widget for GTK"
HOMEPAGE="http://gtkspell.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="3/0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="+introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	app-text/enchant:2
	app-text/iso-codes
	dev-libs/glib:2
	x11-libs/gtk+:3[introspection?]
	>=x11-libs/pango-1.8.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/gtk-doc-am-1.17
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	vala? ( $(vala_depend) )"

src_configure() {
	use vala && vala_setup

	gnome2_src_configure \
		$(use_enable introspection) \
		$(use_enable vala)
}
