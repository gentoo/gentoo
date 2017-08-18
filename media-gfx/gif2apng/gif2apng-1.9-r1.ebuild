# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="create an APNG from a GIF"
HOMEPAGE="https://sourceforge.net/projects/gif2apng/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}-src.zip"

LICENSE="ZLIB LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib
	app-arch/zopfli:="
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default

	# remove bundled libs
	rm -r zlib zopfli || die

	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
