# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nx/nx-3.5.0.20.ebuild,v 1.5 2015/03/27 14:47:37 voyageur Exp $

EAPI=4
inherit autotools eutils multilib

DESCRIPTION="NX compression technology core libraries"
HOMEPAGE="http://www.x2go.org/doku.php/wiki:libs:nx-libs"

SRC_URI="http://code.x2go.org/releases/source/nx-libs/nx-libs-${PV}-full.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="elibc_glibc"

RDEPEND=">=media-libs/libpng-1.2.8
	>=sys-libs/zlib-1.2.3
	virtual/jpeg"

DEPEND="${RDEPEND}
		x11-misc/gccmakedep
		x11-misc/imake
		x11-proto/inputproto"

S=${WORKDIR}/nx-libs-${PV}

src_prepare() {
	# For nxcl/qtnx
	cd "${S}"/nxproxy
	epatch "${FILESDIR}"/${PN}-3.2.0-nxproxy_read_from_stdin.patch

	cd "${S}"
	# Fix sandbox violation
	epatch "${FILESDIR}"/1.5.0/nx-x11-1.5.0-tmp-exec.patch
	# -fPIC
	epatch "${FILESDIR}"/1.5.0/nxcomp-1.5.0-pic.patch
	# Drop force -O3, set AR/RANLIB and
	# run autoreconf in all neeed folders
	epatch "${FILESDIR}"/${PN}-3.5.0.17-cflags_ar_ranlib.patch
	for i in nxcomp nxcompext nxcompshad nxproxy; do
		cd "${S}"/${i}
		eautoreconf ${i}
		cd "${S}"
	done

	# From xorg-x11-6.9.0-r3.ebuild
	cd "${S}/nx-X11"
	HOSTCONF="config/cf/host.def"
	echo "#define CcCmd $(tc-getCC)" >> ${HOSTCONF}
	echo "#define OptimizedCDebugFlags ${CFLAGS} GccAliasingArgs" >> ${HOSTCONF}
	echo "#define OptimizedCplusplusDebugFlags ${CXXFLAGS} GccAliasingArgs" >> ${HOSTCONF}
	# Respect LDFLAGS
	echo "#define ExtraLoadFlags ${LDFLAGS}" >> ${HOSTCONF}
	echo "#define SharedLibraryLoadFlags -shared ${LDFLAGS}" >> ${HOSTCONF}
}

src_configure() {
	cd "${S}"/nxproxy
	econf
}

src_compile() {
	cd "${S}/nx-X11"
	FAST=1 emake World WORLDOPTS="" MAKE="make" \
		AR="$(tc-getAR) clq" RANLIB="$(tc-getRANLIB)" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)"

	cd "${S}"/nxproxy
	emake
}

src_install() {
	NX_ROOT=/usr/$(get_libdir)/NX

	for x in nxagent nxauth nxproxy; do
		make_wrapper $x ./$x ${NX_ROOT}/bin ${NX_ROOT}/$(get_libdir) ||
			die " $x wrapper creation failed"
	done

	into ${NX_ROOT}
	dobin "${S}"/nx-X11/programs/Xserver/nxagent
	dobin "${S}"/nx-X11/programs/nxauth/nxauth
	dobin "${S}"/nxproxy/nxproxy

	for lib in X11 Xau Xcomposite Xdamage Xdmcp Xext Xfixes Xinerama Xpm Xrandr Xrender Xtst;
	do
		dolib.so "${S}"/nx-X11/lib/${lib}/libNX_${lib}.so*
	done
	dolib.so "${S}"/nx-X11/lib/freetype2/libNX_freetype.so*

	dolib.so "${S}"/nxcomp/libXcomp.so*
	dolib.so "${S}"/nxcompext/libXcompext.so*
	dolib.so "${S}"/nxcompshad/libXcompshad.so*
}
