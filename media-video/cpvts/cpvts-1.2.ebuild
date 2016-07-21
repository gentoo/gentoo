# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

IUSE=""

MY_S="${WORKDIR}/${PN}"

DESCRIPTION="raw copy title sets from a DVD to your harddisc"
SRC_URI="http://www.lallafa.de/bp/files/${P}.tgz"
HOMEPAGE="http://www.lallafa.de/bp/cpvts.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

DEPEND="media-libs/libdvdread"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-dvdread.patch"
}

echodo() {
	echo "$@"
	"$@" || die "failed"
}

src_compile () {
	cd ${MY_S} || die

	echodo $(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,-rpath,/usr/lib -o cpvts \
		cpvts.c -lm -ldvdread
}

src_install () {
	dobin ${MY_S}/${PN} || die
}
