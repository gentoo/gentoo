# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="unpacker for various archiving formats, e.g. rar v3"
HOMEPAGE="http://unarchiver.c3.cx/"
SRC_URI="https://theunarchiver.googlecode.com/files/${PN}${PV}_src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="gnustep-base/gnustep-base
	>=gnustep-base/gnustep-make-2.6.0[native-exceptions]
	dev-libs/icu"
DEPEND="${RDEPEND}
	sys-devel/gcc[objc]"

S="${WORKDIR}/The Unarchiver/XADMaster"

src_compile() {
	emake -f Makefile.linux \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		OBJCC="$(tc-getCC)" \
		C_OPTS="-std=gnu99 ${CFLAGS} ${CPPFLAGS}" \
		CXX_OPTS="${CXXFLAGS} ${CPPFLAGS}" \
		OBJC_OPTS="-std=gnu99 ${CFLAGS} ${CPPFLAGS}" \
		LD="$(tc-getCXX)" \
		LDFLAGS="-Wl,--whole-archive -fexceptions -fgnu-runtime ${LDFLAGS}"
}

src_install() {
	dobin {ls,un}ar
	doman ../Extra/{ls,un}ar.1
}
