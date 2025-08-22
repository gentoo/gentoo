# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_13 )

inherit distutils-r1

DESCRIPTION="Sphinx spelling extension"
HOMEPAGE="
	https://github.com/mgaitan/sphinxcontrib-mermaid
	https://pypi.org/project/sphinxcontrib-mermaid/
"
# pypi does not include test files, so we use the GitHub tarball
SRC_URI="
	https://github.com/mgaitan/sphinxcontrib-mermaid/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64"

RDEPEND="
	>=dev-python/sphinx-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	distutils_write_namespace sphinxcontrib
	rm -rf sphinxcontrib || die
	epytest tests
}
