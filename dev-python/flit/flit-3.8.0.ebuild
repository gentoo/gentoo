# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="Simplified packaging of Python modules"
HOMEPAGE="https://github.com/pypa/flit https://flit.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/flit_core-${PV}[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests_download[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/tomli-w[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	sys-apps/grep
	test? (
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# requires Internet
	tests/test_config.py::test_invalid_classifier
	# failing due to Gentoo pip patches
	tests/test_install.py::InstallTests::test_install_data_dir
	tests/test_install.py::InstallTests::test_install_module_pep621
	tests/test_install.py::InstallTests::test_symlink_data_dir
	tests/test_install.py::InstallTests::test_symlink_module_pep621
)

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinxcontrib-github-alt \
	dev-python/pygments-github-lexers \
	dev-python/sphinx-rtd-theme

src_prepare() {
	# make sure system install is used
	rm -r flit_core || die
	distutils-r1_src_prepare
}
