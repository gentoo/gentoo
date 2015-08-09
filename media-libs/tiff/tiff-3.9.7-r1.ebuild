# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# this ebuild is only for the libtiff.so.3 (+ 4) and libtiffxx.so.3 (+ 4) SONAME for ABI compat

inherit eutils libtool multilib multilib-minimal

DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${P}.tar.gz"

LICENSE="libtiff"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 m68k ~mips ~ppc ~ppc64 s390 sh ~sparc x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cxx jbig jpeg zlib"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2[${MULTILIB_USEDEP}] )
	jbig? ( >=media-libs/jbigkit-2.1[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	!media-libs/tiff-compat
	!=media-libs/tiff-3*:0
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r10
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-CVE-2012-{4447,4564,5581}.patch \
		"${FILESDIR}"/${P}-tiffinfo-exif.patch \
		"${FILESDIR}"/${P}-printdir-width.patch

	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--libdir=/libdir \
		--disable-static \
		$(use_enable cxx) \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		$(use_enable jbig) \
		--without-x
}

multilib_src_install() {
	# Let `make install` and libtool handle insecure runpath(s)
	dodir tmp
	emake DESTDIR="${ED}/tmp" install

	# .so.3 (upstream) is used by sci-chemistry/icm
	# .so.4 (Debian) is used by net-im/skype
	exeinto /usr/$(get_libdir)
	doexe "${ED}"/tmp/libdir/libtiff$(get_libname 3)
	dosym libtiff$(get_libname 3) /usr/$(get_libdir)/libtiff$(get_libname 4)
	if use cxx; then
		doexe "${ED}"/tmp/libdir/libtiffxx$(get_libname 3)
		dosym libtiffxx$(get_libname 3) /usr/$(get_libdir)/libtiffxx$(get_libname 4)
	fi

	rm -rf "${ED}"/tmp
}

multilib_src_install_all() {
	# (avoid installing docs)
	:
}
