# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Magnificent app which corrects your previous console command"
HOMEPAGE="https://github.com/nvbn/thefuck"
SRC_URI="https://github.com/nvbn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/pyte[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e "/import pip/s/^/#/" -e "/pip.__version__/,+3 s/^/#/" setup.py || die
	distutils-r1_python_prepare_all
}
