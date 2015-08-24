# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit eutils gnome2 virtualx

DESCRIPTION="a library for writing single instance application"
HOMEPAGE="https://live.gnome.org/LibUnique"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE="dbus doc +introspection"

RDEPEND=">=dev-libs/glib-2.12:2
	>=x11-libs/gtk+-2.11:2[introspection?]
	x11-libs/libX11
	dbus? (
		>=dev-libs/dbus-glib-0.70
		sys-apps/dbus[X] )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.11 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.3 )"
# For eautoreconf
#	dev-util/gtk-doc-am

pkg_setup() {
	DOCS="AUTHORS NEWS ChangeLog README TODO"
	G2CONF="${G2CONF}
		--disable-maintainer-flags
		--disable-static
		--enable-bacon
		$(use_enable introspection)
		$(use_enable dbus)"
}

src_prepare() {
	gnome2_src_prepare

	# Include NUL terminator in unique_message_data_get_filename()
	epatch "${FILESDIR}/${P}-include-terminator.patch"

	# test-unique: Resolve format string issues
	epatch "${FILESDIR}/${P}-fix-test.patch"

	# Remove compiler warnings
	epatch "${FILESDIR}/${P}-compiler-warnings.patch"

	# Remove G_CONST_RETURN usage, now that its gone in glib.
	epatch "${FILESDIR}/${PN}-1.1.6-G_CONST_RETURN.patch"

	sed -e 's/-D.*_DISABLE_DEPRECATED//' -i unique/Makefile.am \
		unique/Makefile.in || die
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
