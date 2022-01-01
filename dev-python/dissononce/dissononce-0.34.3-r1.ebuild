# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A python implementation for Noise Protocol Framework"
HOMEPAGE="https://github.com/tgalal/dissononce"
SRC_URI="https://github.com/tgalal/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples test"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/transitions[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-test-requirements.patch" )

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	use examples && dodoc examples/patterns/*.py
}
