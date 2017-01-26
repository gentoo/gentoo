# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="unpacker for various archiving formats, e.g. rar v3"
HOMEPAGE="https://unarchiver.c3.cx/"
SRC_URI="https://unarchiver.c3.cx/downloads/${PN}${PV}_src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="gnustep-base/gnustep-base
	dev-libs/icu:=
	sys-libs/zlib
	app-arch/bzip2"
DEPEND="${RDEPEND}
	>=gnustep-base/gnustep-make-2.6.0[native-exceptions]
	sys-devel/gcc[objc]"

S="${WORKDIR}/The Unarchiver/XADMaster"

src_prepare() {
	# avoid jobserver warning, upstream bug:
	# https://bitbucket.org/WAHa_06x36/theunarchiver/issues/918/dont-call-make-from-makefile
	sed -i -e 's:make:$(MAKE):g' Makefile.linux
}

src_compile() {
	emake -f Makefile.linux \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		OBJCC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		OBJCFLAGS="${CFLAGS}" \
		LD="$(tc-getCXX)" \
		LDFLAGS="-Wl,--whole-archive -fexceptions -fgnu-runtime ${LDFLAGS}"
}

src_install() {
	dobin {ls,un}ar
	doman ../Extra/{ls,un}ar.1
}
