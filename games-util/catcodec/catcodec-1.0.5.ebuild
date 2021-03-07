# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="Decodes and encodes sample catalogues for OpenTTD"
HOMEPAGE="http://www.openttd.org/en/download-catcodec"
SRC_URI="http://binaries.openttd.org/extra/catcodec/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE=""

src_prepare() {
	default
	tc-export CXX
}

src_compile() {
	emake VERBOSE=1
}

src_install() {
	dobin catcodec
	dodoc changelog.txt docs/readme.txt
	doman docs/catcodec.1
}
