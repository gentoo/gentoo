# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/glib/glib-1.2.10-r6.ebuild,v 1.4 2015/06/21 10:48:52 zlogene Exp $

EAPI=5
GNOME_TARBALL_SUFFIX="gz"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 libtool flag-o-matic portability multilib-minimal

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://www.gtk.org/"
SRC_URI="${SRC_URI}
	 mirror://gentoo/glib-1.2.10-r1-as-needed.patch.bz2
"

LICENSE="LGPL-2.1+"
SLOT="1"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="hardened static-libs"

DEPEND=""
RDEPEND=""

MULTILIB_CHOST_TOOLS=(/usr/bin/glib-config)

src_prepare() {
	epatch "${FILESDIR}"/${P}-automake.patch
	epatch "${FILESDIR}"/${P}-m4.patch
	epatch "${FILESDIR}"/${P}-configure-LANG.patch #133679

	# Allow glib to build with gcc-3.4.x #47047
	epatch "${FILESDIR}"/${P}-gcc34-fix.patch

	# Fix for -Wl,--as-needed (bug #133818)
	epatch "${DISTDIR}"/glib-1.2.10-r1-as-needed.patch.bz2

	# build failure with automake-1.13
	epatch "${FILESDIR}/${P}-automake-1.13.patch"

	use ppc64 && use hardened && replace-flags -O[2-3] -O1
	sed -i "/libglib_la_LDFLAGS/i libglib_la_LIBADD = $(dlopen_lib)" Makefile.am || die

	rm -f acinclude.m4 #168198

	mv configure.in configure.ac || die

	eautoreconf
	elibtoolize
	gnome2_src_prepare
}

multilib_src_configure() {
	# Bug 48839: pam fails to build on ia64
	# The problem is that it attempts to link a shared object against
	# libglib.a; this library needs to be built with -fPIC.  Since
	# this package doesn't contain any significant binaries, build the
	# whole thing with -fPIC (23 Apr 2004 agriffis)
	append-flags -fPIC

	ECONF_SOURCE="${S}" \
	gnome2_src_configure \
		--with-threads=posix \
		--enable-debug=yes \
		$(use_enable static-libs static)
}

multilib_src_install() {
	gnome2_src_install

	chmod 755 "${ED}"/usr/$(get_libdir)/libgmodule-1.2.so.* || die
}

multilib_src_install_all() {
	einstalldocs
	dohtml -r docs
}
