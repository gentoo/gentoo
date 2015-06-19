# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/tapiir/tapiir-0.7.2.ebuild,v 1.9 2011/03/20 20:06:58 jlec Exp $

EAPI=2
inherit eutils

DESCRIPTION="a flexible audio effects processor, inspired on the classical magnetic tape delay systems"
HOMEPAGE="http://www.iua.upf.es/~mdeboer/projects/tapiir/"
SRC_URI="http://www.iua.upf.es/~mdeboer/projects/tapiir/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="
	media-sound/jack-audio-connection-kit
	media-libs/alsa-lib
	x11-libs/fltk:1"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-ldflags.patch"
}

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	doman doc/${PN}.1
	dodoc AUTHORS doc/${PN}.txt
	dohtml doc/*.html doc/images/*.png
	insinto /usr/share/${PN}/examples
	doins doc/examples/*.mtd || die "doins failed."
}
