# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3gain/mp3gain-1.5.2.ebuild,v 1.6 2015/08/03 11:56:08 ago Exp $

EAPI=2
inherit toolchain-funcs

MY_P=${P//./_}

DESCRIPTION="A program to analyze and adjust MP3 files to same volume"
HOMEPAGE="http://mp3gain.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	sed -i \
		-e 's:CFLAGS= -Wall -O2:CFLAGS+= -Wall:' \
		-e 's:$(CC) -o:$(CC) $(LDFLAGS) -o:' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin mp3gain || die
}
