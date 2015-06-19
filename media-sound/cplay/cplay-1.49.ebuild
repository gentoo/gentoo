# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cplay/cplay-1.49.ebuild,v 1.21 2014/08/10 21:05:01 slyfox Exp $

EAPI=2
PYTHON_DEPEND="2"
inherit python

DESCRIPTION="A Curses front-end for various audio players"
SRC_URI="http://mask.tf.hut.fi/~flu/cplay/${P}.tar.gz"
HOMEPAGE="http://mask.tf.hut.fi/~flu/hacks/cplay/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc ppc64 sparc x86"
IUSE="mp3 vorbis"

RDEPEND="vorbis? ( media-sound/vorbis-tools )
	mp3? ( || ( media-sound/mpg123
		media-sound/mpg321
		media-sound/madplay
		media-sound/splay ) )"
DEPEND="sys-devel/gettext"

src_prepare() {
	sed -i -e 's:make:$(MAKE):' Makefile || die
	sed -i -e 's:/usr/local:/usr:' cplay || die
	python_convert_shebangs 2 cplay
}

src_install() {
	emake PREFIX="${D}/usr" recursive-install || die
	dobin cplay || die
	doman cplay.1
	dodoc ChangeLog README TODO
}
