# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Curio is a coroutine-based library for concurrent systems programming"
HOMEPAGE="
	https://github.com/dabeaz/curio
	https://pypi.org/project/curio
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

IUSE="examples"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="test? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs --no-autodoc
distutils_enable_tests pytest

python_prepare_all() {
	# Contains hard coded path, fails in emerge
	rm -r tests/__pycache__ || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
