# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libjackasyn/libjackasyn-0.13.ebuild,v 1.8 2014/08/10 21:08:55 slyfox Exp $

inherit eutils toolchain-funcs

IUSE="debug"

DESCRIPTION="An application/library for connecting OSS apps to Jackit"
HOMEPAGE="http://gige.xdv.org/soft/libjackasyn"
SRC_URI="http://gige.xdv.org/soft/libjackasyn/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"

DEPEND="media-sound/jack-audio-connection-kit
	media-libs/libsamplerate"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-qa.patch"
	epatch "${FILESDIR}/${P}-pic.patch"
	epatch "${FILESDIR}/${P}-libdir.patch"
	epatch "${FILESDIR}/${P}-execprefix.patch"
	epatch "${FILESDIR}/${P}-tests.patch"
}

src_compile() {
	tc-export CC
	local myconf
	use debug && myconf="--enable-debug"
	econf ${myconf} || die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS CHANGELOG WORKING TODO README
}
