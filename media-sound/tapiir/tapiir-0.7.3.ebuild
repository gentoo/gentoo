# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="a flexible audio effects processor, inspired on the classical magnetic tape delay systems"
HOMEPAGE="http://www.resorama.com/maarten/tapiir/"
SRC_URI="http://www.resorama.com/maarten/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86"

RDEPEND="
	media-sound/jack-audio-connection-kit
	media-libs/alsa-lib
	x11-libs/fltk:1
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.7.2-ldflags.patch

	cp "${FILESDIR}"/${P}-acinclude.m4 acinclude.m4 || die

	eautoreconf
}

src_configure() {
	econf --disable-dependency-tracking
}

src_install() {
	default
	doman doc/${PN}.1
	dodoc AUTHORS doc/${PN}.txt
	dohtml doc/*.html doc/images/*.png
	insinto /usr/share/${PN}/examples
	doins doc/examples/*.mtd
}
