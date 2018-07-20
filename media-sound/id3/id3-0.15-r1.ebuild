# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="changes the id3 tag in an mp3 file"
HOMEPAGE="http://lly.org/~rcw/abcde/page"
SRC_URI="http://lly.org/~rcw/id3/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

src_prepare() {
	default
	sed -i -e "s:-s::" Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}
