# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

IUSE=""

S="${WORKDIR}/${PN}"

DESCRIPTION="raw copy title sets from a DVD to your harddisc"
SRC_URI="http://www.lallafa.de/bp/files/${P}.tgz"
HOMEPAGE="http://www.lallafa.de/bp/cpvts.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

DEPEND="media-libs/libdvdread"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-dvdread.patch"
)

echodo() {
	echo "$@"
	"$@" || die "failed"
}

src_compile () {
	echodo $(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,-rpath,/usr/lib -o cpvts \
		cpvts.c -lm -ldvdread
}

src_install () {
	dobin ${PN}
}
