# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Convert CD images from bin/cue to iso+wav/cdr"
HOMEPAGE="http://he.fi/bchunk/"
SRC_URI="http://he.fi/bchunk/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~sparc x86 ~x64-macos"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LD="$(tc-getCC)"
}

src_install() {
	dobin bchunk
	doman bchunk.1
	einstalldocs
	dodoc bchunk.spec
}
