# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{10..11} )

inherit gnome2 python-any-r1 vala virtualx

DESCRIPTION="GLib bindings for the Telepathy D-Bus protocol"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug +introspection +vala"
REQUIRED_USE="vala? ( introspection )"
# Broken for a long time and upstream doesn't care
# https://bugs.freedesktop.org/show_bug.cgi?id=63212
RESTRICT="test"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/dbus-glib-0.90
	introspection? ( >=dev-libs/gobject-introspection-1.30 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxslt
	dev-util/glib-utils
	dev-build/gtk-doc-am
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"
# See bug 504744 for reference
PDEPEND="
	net-im/telepathy-mission-control
"

src_configure() {
	use vala && vala_setup

	gnome2_src_configure \
		--disable-installed-tests \
		$(use_enable debug backtrace) \
		$(use_enable debug debug-cache) \
		$(use_enable introspection) \
		$(use_enable vala vala-bindings)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	# Needs dbus for tests (auto-launched)
	virtx emake -j1 check
}
