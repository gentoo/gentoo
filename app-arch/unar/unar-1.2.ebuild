# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unar/unar-1.2.ebuild,v 1.2 2014/08/10 01:43:12 patrick Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Unpacker for various archiving formats, e.g. rar v3"
HOMEPAGE="http://unarchiver.c3.cx/"
SRC_URI="http://theunarchiver.googlecode.com/files/${PN}${PV}_src.zip"
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
		CC="$(tc-getCC)" \
		OBJCC="$(tc-getCC)" \
		C_OPTS="-std=gnu99 ${CFLAGS}" \
		OBJC_OPTS="-std=gnu99 ${CFLAGS}" \
		LD="$(tc-getCC)" \
		LDFLAGS="-Wl,--whole-archive -fexceptions -fgnu-runtime \
		${LDFLAGS}" || die "emake failed"
}

src_install() {
	dobin unar lsar || die "dobin failed"
	doman ../Extra/lsar.1 ../Extra/unar.1 || die "doman failed"
}
