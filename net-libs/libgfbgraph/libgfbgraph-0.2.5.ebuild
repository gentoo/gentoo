# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="gfbgraph"
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="A GObject library for Facebook Graph API"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgfbgraph/"

LICENSE="LGPL-2.1+"
SLOT="0.2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+introspection"

DEPEND="
	dev-libs/glib:2
	dev-libs/json-glib[introspection?]
	net-libs/libsoup:2.4[introspection?]
	net-libs/gnome-online-accounts
	net-libs/rest:0.7[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gtk-doc
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
"
# gtk-doc needed for autoreconf

src_prepare() {
	# Test requires a credentials.ini file.
	# https://gitlab.gnome.org/GNOME/libgfbgraph/-/issues/7#note_802926
	sed -i -e 's:TESTS = gtestutils:TESTS =:' tests/Makefile.am || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection)
}

src_install() {
	gnome2_src_install
	# Remove files installed in the wrong place
	# https://gitlab.gnome.org/GNOME/libgfbgraph/-/issues/10
	rm -rf "${ED}"/usr/doc
}
