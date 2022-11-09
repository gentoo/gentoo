# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="xml(+)"
inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Daemon that centralizes the communication logging within the Telepathy framework"
HOMEPAGE="https://telepathy.freedesktop.org/wiki/Logger"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.bz2
	https://gitlab.freedesktop.org/telepathy/telepathy-logger/-/merge_requests/1.patch
		-> ${P}-py3.patch"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~x86-linux"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=sys-apps/dbus-1.1
	>=dev-libs/dbus-glib-0.82
	>=net-libs/telepathy-glib-0.19.2[introspection?]
	dev-libs/libxml2
	dev-libs/libxslt
	dev-db/sqlite:3
	introspection? ( >=dev-libs/gobject-introspection-0.9.6 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.10
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

PATCHES=( "${DISTDIR}"/${P}-py3.patch )

src_configure() {
	# --enable-debug needed due to https://bugs.freedesktop.org/show_bug.cgi?id=83390
	gnome2_src_configure \
		$(use_enable introspection) \
		--enable-debug \
		--enable-public-extensions \
		--disable-coding-style-checks \
		--disable-Werror \
		--disable-static
}

src_test() {
	virtx emake -j1 check
}
