# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1+"
SLOT="0.48"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc ~x86 ~x86-linux"
IUSE="test valadoc"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.48.0:2
	>=dev-libs/vala-common-${PV}
	valadoc? ( >=media-gfx/graphviz-2.16 )
	!<net-libs/libsoup-2.66.2[vala]
" # Older libsoup generates a libsoup-2.4.vapi that isn't fine for vala:0.46 anymore
# We block here, so libsoup[vala] consumers wouldn't have to >= it, which would be bad
# as the newer is not required with older vala when those are picked instead of 0.46.
# vala-0.45.91 ships a broken libsoup-2.4.vapi copy too, but that'll be fixed by 0.45.92
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
