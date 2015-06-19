# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/ponyprog/ponyprog-2.07c-r1.ebuild,v 1.2 2014/08/28 15:10:37 ssuominen Exp $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Serial device programmer"
HOMEPAGE="http://www.lancos.com/ppwin95.html"
SRC_URI="mirror://sourceforge/${PN}/Pony_Prog2000-${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libX11
	x11-misc/xdg-utils"
DEPEND="${RDEPEND}
	|| ( media-gfx/graphicsmagick[imagemagick] media-gfx/imagemagick )"

S="${WORKDIR}/PonyProg2000-${PV}"

src_prepare() {
	sed -i -e '/CFLAGS/s:-O2::' v/Config.mk || die
	sed -i -e '/include.*<asm\/io.h>/s:asm:sys:' *.cpp || die
	sed -i -e 's/netscape/xdg-open/' e2cmdw.cpp || die

	convert ponyprog.ico ponyprog.png

	epatch \
		"${FILESDIR}/${PN}-2.07a-gcc43.patch" \
		"${FILESDIR}/${PN}-2.07c-build.patch"
	epatch_user
}

src_compile() {
	tc-export CC CXX
	# most of build is C++, but it uses CFLAGS
	CFLAGS="${CXXFLAGS}" emake HOMEV="${S}/v"
}

src_install() {
	dobin bin/ponyprog2000
	keepdir /var/lock/uucp
	fowners uucp:uucp /var/lock/uucp
	fperms 755 /var/lock/uucp
	doicon ponyprog.png
	make_desktop_entry ponyprog2000 PonyProg2000 ponyprog
}

pkg_postinst() {
	elog "To use the COM port in user mode (not as root), you need to"
	elog "be in the 'uucp' group."
	elog
	elog "To use the LPT port in user mode (not as root) you need a kernel with"
	elog "ppdev, parport and parport_pc compiled in or as modules. You need the"
	elog "rights to write to /dev/parport? devices."
}
