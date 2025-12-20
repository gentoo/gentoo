# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx

DESCRIPTION="A library for writing single instance application"
HOMEPAGE="https://wiki.gnome.org/Attic/LibUnique"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
IUSE="debug +introspection"

RDEPEND="
	>=dev-libs/glib-2.25.7:2
	sys-apps/dbus[X]
	>=x11-libs/gtk+-2.90.0:3[introspection?]
	x11-libs/libX11
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.11
	virtual/pkgconfig
"
# For eautoreconf
#	dev-build/gtk-doc-am

src_configure() {
	# --disable-dbus means gdbus is used instead of dbus-glib
	gnome2_src_configure \
		--disable-maintainer-flags \
		--disable-dbus \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable introspection)
}

src_test() {
	cd "${S}/tests" || die
	cp "${FILESDIR}/run-tests" . || die "Unable to cp \${FILESDIR}/run-tests"
	virtx emake -f run-tests
}
