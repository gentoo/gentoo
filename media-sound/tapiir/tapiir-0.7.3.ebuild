# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A flexible audio effects processor, inspired by classical tape delay systems"
HOMEPAGE="http://www.resorama.com/maarten/tapiir/"
SRC_URI="http://www.resorama.com/maarten/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="
	media-sound/jack-audio-connection-kit
	media-libs/alsa-lib
	x11-libs/fltk:1
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.7.2-ldflags.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	cp "${FILESDIR}"/${P}-acinclude.m4 acinclude.m4 || die
	eautoreconf
}

src_install() {
	local HTML_DOCS=( doc/{*.html,images/*.png} )
	default

	doman doc/${PN}.1
	dodoc doc/${PN}.txt

	insinto /usr/share/${PN}/examples
	doins doc/examples/*.mtd
}
