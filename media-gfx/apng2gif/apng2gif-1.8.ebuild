# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="create a GIF from an APNG"
HOMEPAGE="https://sourceforge.net/projects/apng2gif/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

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
