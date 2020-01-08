# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A commandline CD Player"
HOMEPAGE="http://www.ta-sa.org/?entry=cdplay"
SRC_URI="http://www.ta-sa.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

DEPEND="!media-sound/cdtool"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin cdplay
	einstalldocs
	dodoc Changes
}
