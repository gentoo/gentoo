# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gam-server/gam-server-0.1.10-r2.ebuild,v 1.10 2014/12/06 16:39:30 ago Exp $

EAPI="5"
GNOME_ORG_MODULE="gamin"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils flag-o-matic libtool multilib gnome.org

DESCRIPTION="Library providing the FAM File Alteration Monitor API"
HOMEPAGE="http://www.gnome.org/~veillard/gamin/"
SRC_URI="${SRC_URI}
	mirror://gentoo/gamin-0.1.9-freebsd.patch.bz2
	http://pkgconfig.freedesktop.org/releases/pkg-config-0.26.tar.gz" # pkg.m4 for eautoreconf

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="debug kernel_linux"

RDEPEND=">=dev-libs/glib-2:2
	>=dev-libs/libgamin-0.1.10
	!app-admin/fam
	!<app-admin/gamin-0.1.10"

DEPEND="${RDEPEND}"

#S=${WORKDIR}/${MY_P}

src_prepare() {
	mv -vf "${WORKDIR}"/pkg-config-*/pkg.m4 "${WORKDIR}"/ || die

	# Fix compile warnings; bug #188923
	epatch "${DISTDIR}/gamin-0.1.9-freebsd.patch.bz2"

	# Fix file-collision due to shared library, upstream bug #530635
	epatch "${FILESDIR}/${PN}-0.1.10-noinst-lib.patch"

	# Fix compilation with latest glib, bug #382783
	epatch "${FILESDIR}/${PN}-0.1.10-G_CONST_RETURN-removal.patch"

	# Fix crosscompilation issues, bug #267604
	epatch "${FILESDIR}/${PN}-0.1.10-crosscompile-fix.patch"

	# Enable linux specific features on armel, upstream bug #588338
	epatch "${FILESDIR}/${P}-armel-features.patch"

	# Fix deadlocks with glib-2.32, bug #413331, upstream #667230
	epatch "${FILESDIR}/${P}-ih_sub_cancel-deadlock.patch"

	# Drop DEPRECATED flags
	sed -i -e 's:-DG_DISABLE_DEPRECATED:$(NULL):g' server/Makefile.am || die

	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:AM_PROG_CC_STDC:AC_PROG_CC:' \
		configure.in || die #466948

	# autoconf is required as the user-cflags patch modifies configure.in
	# however, elibtoolize is also required, so when the above patch is
	# removed, replace the following call with a call to elibtoolize
	AT_M4DIR="${WORKDIR}" eautoreconf
}

src_configure() {
	# fixes bug 225403
	#append-flags "-D_GNU_SOURCE"

	if ! has_version virtual/pkgconfig; then
		export DAEMON_CFLAGS="-I/usr/include/glib-2.0 -I/usr/$(get_libdir)/glib-2.0/include"
		export DAEMON_LIBS="-lglib-2.0"
	fi

	econf \
		--disable-debug \
		--disable-libgamin \
		--without-python \
		$(use_enable kernel_linux inotify) \
		$(use_enable debug debug-api)
}

src_install() {
	emake DESTDIR="${D}" install || die
}
