# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="rdepend"
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Compiler of NML files into GRF/NFO files"
HOMEPAGE="https://github.com/OpenTTD/nml"
SRC_URI="https://github.com/OpenTTD/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/pillow[zlib,${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

DOCS=( "README.md" "docs/changelog.txt" )

src_install() {
	distutils-r1_src_install

	doman docs/nmlc.1
}
