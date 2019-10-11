# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

DESCRIPTION="fast, low complexity waveform coder (i.e. audio compressor)"
HOMEPAGE="http://shnutils.freeshell.org/shorten/"
SRC_URI="http://shnutils.freeshell.org/shorten/dist/src/${P}.tar.gz"

LICENSE="shorten"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc sparc x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-tests.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
