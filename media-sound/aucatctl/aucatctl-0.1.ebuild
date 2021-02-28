# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A tool for controlling aucat and/or sndiod volume through MIDI"
HOMEPAGE="http://www.sndio.org/"
SRC_URI="http://www.sndio.org/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libbsd
	media-sound/sndio:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i \
		-e 's?/usr/local?/usr?g' \
		-e 's?man/man1?share/man/man1?g' \
		-e 's?LDADD = -lsndio?LDADD = -lbsd -lsndio?' \
		Makefile || die "Failed modifying Makefile"
}

src_compile() {
	tc-export CC
	default
}
