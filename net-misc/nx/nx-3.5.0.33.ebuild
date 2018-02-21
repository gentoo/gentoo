# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils toolchain-funcs

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

src_prepare() {
	default

	# run autoreconf in all neeed folders
	for i in nxcomp nxcompext nxcompshad nxproxy; do
		pushd "${S}"/${i} || die
		eautoreconf
		popd
	done

	# From xorg-x11-6.9.0-r3.ebuild
	pushd "${S}/nx-X11"  || die
	HOSTCONF="config/cf/host.def"
	echo "#define CcCmd $(tc-getCC)" >> ${HOSTCONF}
	echo "#define OptimizedCDebugFlags ${CFLAGS} GccAliasingArgs" >> ${HOSTCONF}
	echo "#define OptimizedCplusplusDebugFlags ${CXXFLAGS} GccAliasingArgs" >> ${HOSTCONF}
	# Respect LDFLAGS
	echo "#define ExtraLoadFlags ${LDFLAGS}" >> ${HOSTCONF}
	echo "#define SharedLibraryLoadFlags -shared ${LDFLAGS}" >> ${HOSTCONF}
	# Disable SunRPC, #370767
	echo "#define HasSecureRPC NO" >> ${HOSTCONF}

}

src_configure() {
	for i in nxcomp nxproxy; do
		pushd "${S}"/${i} || die
		econf
		popd
	done

	emake -C nx-X11 BuildEnv
}

src_compile() {
	emake -C nxcomp

	emake -C nx-X11/lib

	for i in nxcompext nxcompshad ; do
		pushd "${S}"/${i} || die
		# Configuration can only run after X11 lib compilation
		econf
		emake
		popd
	done

	pushd "${S}"/nx-X11 || die
	emake -C programs/Xserver
	emake -C programs/nxauth
	popd

	emake -C nxproxy
}

src_install() {
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
}
