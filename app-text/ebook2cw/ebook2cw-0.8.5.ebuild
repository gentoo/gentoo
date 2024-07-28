# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Convert ebooks to Morse MP3s/OGGs"
HOMEPAGE="https://fkurz.net/ham/ebook2cw.html"
SRC_URI="https://fkurz.net/ham/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

DEPEND="
	media-sound/lame
	media-libs/libvorbis
	media-libs/libogg
"

src_prepare() {
	# avoid prestripping of 'qrq' binary
	sed -i -e "s/install -s -m/install -m/" Makefile || die
	# fix install dir for doc files
	sed -i -e "s#/doc/ebook2cw/#/doc/${P}/#g" Makefile || die
	eapply_user
}

src_install() {
	emake DESTDIR="${D}/usr" install
	dodoc ChangeLog
}
