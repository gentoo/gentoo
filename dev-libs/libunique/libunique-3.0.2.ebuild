# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="xz"
GNOME2_LA_PUNT="yes"

inherit gnome2 virtualx

DESCRIPTION="a library for writing single instance application"
HOMEPAGE="http://live.gnome.org/LibUnique"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE="doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.25.7:2
	sys-apps/dbus[X]
	>=x11-libs/gtk+-2.90.0:3[introspection?]
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.13 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0 )"
# For eautoreconf
#	dev-util/gtk-doc-am

pkg_setup() {
	DOCS="AUTHORS NEWS ChangeLog README TODO"
	# --disable-dbus means gdbus is used instead of dbus-glib
	G2CONF="${G2CONF}
		--disable-static
		--disable-maintainer-flags
		--disable-dbus
		$(use_enable introspection)"
}

src_prepare() {
	# should we sed Makefile.am instead and run eautoreconf?
	sed -i -e '/DG.*_DISABLE_DEPRECATED/d' unique/Makefile.in || die
	gnome2_src_prepare
}

src_test() {
	cd "${S}/tests"

	# Fix environment variable leakage (due to `su` etc)
	unset DBUS_SESSION_BUS_ADDRESS

	# Force Xemake to use Xvfb, bug 279840
	unset XAUTHORITY
	unset DISPLAY

	cp "${FILESDIR}/run-tests" . || die "Unable to cp \${FILESDIR}/run-tests"
	Xemake -f run-tests || die "Tests failed"
}
