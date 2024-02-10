# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Compiler of NML files into GRF/NFO files"
HOMEPAGE="https://github.com/OpenTTD/nml/"
SRC_URI="https://github.com/OpenTTD/nml/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_USEDEP},zlib]
		dev-python/ply[${PYTHON_USEDEP}]
	')
"

python_test() {
	emake regression
}

src_install() {
	local DOCS=( README.md docs/changelog.txt )
	distutils-r1_src_install

	doman docs/nmlc.1
}
