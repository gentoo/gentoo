# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala https://gitlab.gnome.org/GNOME/vala"

LICENSE="LGPL-2.1+"
SLOT="0.56"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~x86-linux"
IUSE="test valadoc"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.48.0:2
	>=dev-libs/vala-common-${PV}
	valadoc? ( >=media-gfx/graphviz-2.16 )
"
DEPEND="${RDEPEND}
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2
		dev-libs/gobject-introspection
	)
"
BDEPEND="
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	app-alternatives/yacc
"

src_configure() {
	# weasyprint enables generation of PDF from HTML
	gnome2_src_configure \
		--disable-unversioned \
		$(use_enable valadoc) \
		VALAC=: \
		WEASYPRINT=:
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
