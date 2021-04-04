# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Decodes and encodes sample catalogues for OpenTTD"
HOMEPAGE="https://www.openttd.org/en/download-catcodec"
SRC_URI="https://binaries.openttd.org/extra/catcodec/${PV}/${P}-source.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"

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
