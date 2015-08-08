# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )
VALA_MIN_API_VERSION="0.18"
VALA_USE_DEPEND="vapigen"

inherit eutils gnome2 python-r1 vala virtualx

DESCRIPTION="GLib bindings for the Telepathy D-Bus protocol"
HOMEPAGE="http://telepathy.freedesktop.org"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"

IUSE="debug +introspection +vala"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	vala? ( introspection )
"

# Broken for a long time and upstream doesn't care
# https://bugs.freedesktop.org/show_bug.cgi?id=63212
RESTRICT="test"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/dbus-glib-0.90
	introspection? ( >=dev-libs/gobject-introspection-1.30 )
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-util/gtk-doc-am
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	${PYTHON_DEPS}
"
# See bug 504744 for reference
PDEPEND="
	net-im/telepathy-mission-control
"

src_configure() {
	python_export_best

	gnome2_src_configure \
		--disable-static \
		--disable-installed-tests \
		$(use_enable debug backtrace) \
		$(use_enable debug debug-cache) \
		$(use_enable introspection) \
		$(use_enable vala vala-bindings)
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	# Needs dbus for tests (auto-launched)
	Xemake -j1 check
}
