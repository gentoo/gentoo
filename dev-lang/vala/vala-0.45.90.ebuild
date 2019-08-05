# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1+"
SLOT="0.46"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-linux"
IUSE="test valadoc"

RDEPEND="
	>=dev-libs/glib-2.48.0:2
	>=dev-libs/vala-common-${PV}
	valadoc? ( >=media-gfx/graphviz-2.16 )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2
		dev-libs/gobject-introspection )
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
