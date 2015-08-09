# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils autotools

DESCRIPTION="language independent text-to-speech system"
HOMEPAGE="http://epos.ure.cas.cz/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 x86"
IUSE=""

DEPEND=">=app-text/sgmltools-lite-3.0.3-r9"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc45.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${FILESDIR}"/${P}-disable-tests.patch

	sed -i -e "s/CCC/#CCC/" configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-charsets \
		--disable-portaudio
}

src_install() {
	default

	doinitd "${FILESDIR}/eposd"
	dodoc WELCOME THANKS Changes "${FILESDIR}/README.gentoo"
}
