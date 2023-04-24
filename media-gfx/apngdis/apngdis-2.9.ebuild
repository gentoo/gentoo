# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Extract PNG frames from an APNG"
HOMEPAGE="https://sourceforge.net/projects/apngdis/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"
S="${WORKDIR}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-zlib.patch
)

src_prepare() {
	default

	# remove bundled libs
	rm -r libpng zlib || die

	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
