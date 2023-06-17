# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Magnificent app which corrects your previous console command"
HOMEPAGE="https://github.com/nvbn/thefuck"
SRC_URI="https://github.com/nvbn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

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

EPYTEST_DESELECT=(
	# failing tests because of trying to access portage's home dir
	tests/test_conf.py
	tests/entrypoints/test_not_configured.py
	tests/test_utils.py::test_get_all_executables_exclude_paths
	tests/test_utils.py::TestCache
)

python_prepare_all() {
	sed -i -e "/import pip/s/^/#/" -e "/pip.__version__/,+3 s/^/#/" setup.py || die
	distutils-r1_python_prepare_all
}
