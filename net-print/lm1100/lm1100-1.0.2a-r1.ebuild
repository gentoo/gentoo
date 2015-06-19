# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/lm1100/lm1100-1.0.2a-r1.ebuild,v 1.3 2014/03/04 20:14:26 ago Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="The Tim Engler's Lexmark 1100 driver"
HOMEPAGE="http://www.linuxprinting.org/show_driver.cgi?driver=lm1100"
MY_P=${P/lm1100-/lm1100.}
SRC_URI="mirror://gentoo/${MY_P}.tar.gz
	mirror://gentoo/${PN}maint.tar.gz"
#http://www.linuxprinting.org/download/printing/${PN}/${PN}maint.tar.gz
#http://www.linuxprinting.org/download/printing/${PN}/${MY_P}.tar.gz

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND=""
S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-compile-gcc-3.4.patch"\
		"${FILESDIR}/${P}-fix-compile-gcc-4.1.patch"\
		"${FILESDIR}/${P}-class.patch"\
		"${FILESDIR}/${P}-makefile.patch"
	cd "${WORKDIR}/${PN}maint" || die
	epatch "${FILESDIR}/${PN}maint-firmware.patch"
}

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	dobin lm1100
	dodoc README RELEASE.txt

	cd "${WORKDIR}/${PN}maint" || die
	dobin lm1100back lm1100change
	insinto "/usr/share/${PN}"
	doins lexmarkback lexmarkchange
	newdoc README README.maint
}
