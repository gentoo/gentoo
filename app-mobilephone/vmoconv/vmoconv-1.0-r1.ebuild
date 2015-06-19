# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/vmoconv/vmoconv-1.0-r1.ebuild,v 1.6 2014/08/10 18:13:24 slyfox Exp $
EAPI=5

inherit eutils autotools

DESCRIPTION="A tool that converts Siemens phones VMO and VMI audio files to gsm and wav"
HOMEPAGE="http://triq.net/obex/"
SRC_URI="http://triq.net/obexftp/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-sound/gsm"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-glibc28.patch"
	epatch "${FILESDIR}/${P}-flags.patch"
	epatch "${FILESDIR}/${P}-external-libgsm.patch"
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die
	eautoreconf
}

src_install() {
	dobin src/vmo2gsm src/gsm2vmo src/vmo2wav
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
