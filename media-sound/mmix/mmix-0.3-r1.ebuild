# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Soundcard mixer for the OSS driver"
HOMEPAGE="https://www.mcmilk.de/projects/mmix/"
SRC_URI="https://www.mcmilk.de/projects/${PN}/dl/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# media-sound/mmix and dev-lang/mmix both install 'mmix' binary, bug #426874
RDEPEND=""
DEPEND="virtual/os-headers"

src_prepare() {
	default
	sed -i -e '/strip/d' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	doman doc/${PN}.1
	dodoc doc/{AUTHORS,CHANGES,FAQ,README}
}
