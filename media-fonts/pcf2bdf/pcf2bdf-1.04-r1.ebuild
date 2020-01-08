# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Converts PCF fonts to BDF fonts"
HOMEPAGE="http://www.tsg.ne.jp/GANA/S/pcf2bdf/"
SRC_URI="http://www.tsg.ne.jp/GANA/S/pcf2bdf/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc s390 sh sparc x86"
IUSE=""

S=${WORKDIR}

PATCHES=(
	"${FILESDIR}"/${P}-64bit.patch
	"${FILESDIR}"/${P}-gzip.patch
)

src_compile() {
	emake -f Makefile.gcc CC="$(tc-getCXX)" CFLAGS="${CXXFLAGS}"
}

src_install() {
	emake -f Makefile.gcc \
		PREFIX="${ED}/usr" \
		MANPATH="${ED}/usr/share/man/man1" \
		install
}
