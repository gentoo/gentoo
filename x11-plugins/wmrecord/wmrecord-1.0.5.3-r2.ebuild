# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="A Dockable General Purpose Recording Utility"
HOMEPAGE="http://ret009t0.eresmas.net/other_software/wmrecord/"
SRC_URI="http://ret009t0.eresmas.net/other_software/wmrecord/${PN}-1.0.5_20040218_0029.tgz"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc x86"

S="${WORKDIR}/${PN}-1.0.5"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	#prevent auto-stripping of binaries. Closes bug #252112
	sed -i 's/install -s -o/install -o/' "${S}/Makefile" || die

	#Honour Gentoo LDFLAGS. Closes bug #336753.
	sed -i 's/-o $@ wmrecord.o/$(LDFLAGS) -o $@ wmrecord.o/' "${S}/Makefile" || die

	#Fix buffer overflow. Closes bug #336754.
	sed -i 's/sprintf(cse, "000");/snprintf(cse, "000", 3);/' "${S}/wmrecord.c" || die
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS} -Wall"
}

src_install() {
	dobin ${PN}
	doman man/${PN}.1
	domenu "${FILESDIR}"/${PN}.desktop
	einstalldocs
}
