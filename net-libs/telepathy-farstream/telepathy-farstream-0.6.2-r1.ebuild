# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Telepathy client library that uses Farstream to handle Call channels"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv x86"
IUSE="examples +introspection"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.60
	media-libs/gstreamer:1.0[introspection?]
	>=net-libs/telepathy-glib-0.21[introspection?]
	net-libs/farstream:0.2=[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.30 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/gtk-doc-am-1.17
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		--disable-Werror \
		$(use_enable introspection)
}

src_install() {
	gnome2_src_install

	if use examples; then
		docinto examples
		dodoc examples/*.c
		docompress -x /usr/share/doc/${PF}/examples

		docinto examples/python
		dodoc examples/python/*.py
		docompress -x /usr/share/doc/${PF}/examples/python
	fi
}
