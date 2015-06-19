# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nx/nx-3.5.0.30.ebuild,v 1.5 2015/04/24 13:55:21 voyageur Exp $

EAPI=5
inherit autotools eutils multilib readme.gentoo

DESCRIPTION="NX compression technology core libraries"
HOMEPAGE="http://www.x2go.org/doku.php/wiki:libs:nx-libs"

SRC_URI="http://code.x2go.org/releases/source/nx-libs/nx-libs-${PV}-full.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="elibc_glibc"

RDEPEND="media-libs/freetype:2
	>=media-libs/libpng-1.2.8:*
	>=sys-libs/zlib-1.2.3
	virtual/jpeg:*"

DEPEND="${RDEPEND}
		x11-libs/libfontenc
		x11-misc/gccmakedep
		x11-misc/imake
		x11-proto/inputproto"

S=${WORKDIR}/nx-libs-${PV}

DOC_CONTENTS="If you get problems with rendering gtk+ apps, enable the xlib-xcb
useflag on x11-libs/cairo."

src_prepare() {
	# For nxcl/qtnx
	cd "${S}"/nxproxy
	epatch "${FILESDIR}"/${PN}-3.2.0-nxproxy_read_from_stdin.patch

	cd "${S}"
	# -fPIC
	epatch "${FILESDIR}"/1.5.0/nxcomp-1.5.0-pic.patch
	# Drop force -O3, set AR/RANLIB
	epatch "${FILESDIR}"/${PN}-3.5.0.17-cflags_ar_ranlib.patch
	# Fix libX11 underlinking, #546868
	epatch "${FILESDIR}"/${P}-fix_X11_underlinking.patch

	# run autoreconf in all neeed folders
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

	dolib.so "${S}"/nxcomp/libXcomp.so*
	dolib.so "${S}"/nxcompext/libXcompext.so*
	dolib.so "${S}"/nxcompshad/libXcompshad.so*

	insinto /etc/nxagent
	newins etc/keystrokes.cfg keystroke.cfg
	doicon nx-X11/programs/Xserver/hw/nxagent/x2go.xpm

	readme.gentoo_create_doc
}
