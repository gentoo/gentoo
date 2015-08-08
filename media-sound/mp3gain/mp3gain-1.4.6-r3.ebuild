# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic toolchain-funcs

IUSE=""

MY_P=${P//./_}
S=${WORKDIR}

DESCRIPTION="MP3Gain automatically adjusts mp3s so that they all have the same volume"
HOMEPAGE="http://mp3gain.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	filter-flags -O*
	sed -i -e "s:CC=.*:CC=$(tc-getCC):" \
		-e "s:CFLAGS= -Wall -O3 -DHAVE_MEMCPY:CFLAGS+= -Wall -DHAVE_MEMCPY:" \
		-e "s:LIBS=.*:LIBS= ${LDFLAGS} -lm:" \
		"${S}"/Makefile \
		|| die "Unable to adjust build system compiler/flags."
	epatch "${FILESDIR}"/${PV}-option-parser.patch
}

src_install () {
	dobin mp3gain
}
