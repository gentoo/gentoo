# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="raw copy title sets from a DVD to your harddisc"
HOMEPAGE="http://www.lallafa.de/bp/cpvts.html"
SRC_URI="http://www.lallafa.de/bp/files/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
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

src_compile() {
	echodo $(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,-rpath,/usr/lib -o cpvts \
		cpvts.c -lm -ldvdread
}

src_install() {
	dobin ${PN}
}
