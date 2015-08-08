# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic toolchain-funcs multilib

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="http://www.zlib.net/"
SRC_URI="http://www.gzip.org/zlib/${P}.tar.bz2
	http://www.zlib.net/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-visibility-support.patch #149929
	epatch "${FILESDIR}"/${PN}-1.2.1-glibc.patch
	epatch "${FILESDIR}"/${PN}-1.2.1-build-fPIC.patch
	epatch "${FILESDIR}"/${PN}-1.2.1-configure.patch #55434
	epatch "${FILESDIR}"/${PN}-1.2.1-fPIC.patch
	epatch "${FILESDIR}"/${PN}-1.2.3-r1-bsd-soname.patch #123571
	epatch "${FILESDIR}"/${PN}-1.2.3-LDFLAGS.patch #126718
	epatch "${FILESDIR}"/${PN}-1.2.3-mingw-implib.patch #288212
	sed -i -e '/ldconfig/d' Makefile*
}

src_compile() {
	tc-export AR CC RANLIB
	case ${CHOST} in
	*-mingw*|mingw*)
		export RC=${CHOST}-windres DLLWRAP=${CHOST}-dllwrap
		emake -f win32/Makefile.gcc prefix=/usr || die
		;;
	*)
		# not an autoconf script, so cant use econf
		./configure --shared --prefix=/usr --libdir=/$(get_libdir) || die
		emake || die
		;;
	esac
}

src_install() {
	einstall libdir="${D}"/$(get_libdir) || die
	rm "${D}"/$(get_libdir)/libz.a
	insinto /usr/include
	doins zconf.h zlib.h

	doman zlib.3
	dodoc FAQ README ChangeLog algorithm.txt

	# we don't need the static lib in /lib
	# as it's only for compiling against
	dolib libz.a

	# all the shared libs go into /lib
	# for NFS based /usr
	case ${CHOST} in
	*-mingw*|mingw*)
		dobin zlib1.dll || die
		dolib libz.dll.a || die
		;;
	*)
		into /
		dolib libz.so.${PV}
		( cd "${D}"/$(get_libdir) ; chmod 755 libz.so.* )
		dosym libz.so.${PV} /$(get_libdir)/libz.so
		dosym libz.so.${PV} /$(get_libdir)/libz.so.1
		gen_usr_ldscript libz.so
		;;
	esac
}
