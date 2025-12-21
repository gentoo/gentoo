# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="A new approach to API documentation in Sphinx"
HOMEPAGE="
	https://sphinx-autoapi.readthedocs.io/
	https://github.com/readthedocs/sphinx-autoapi/
	https://pypi.org/project/sphinx-autoapi/
"
# sdist is missing docs, as of 2.1.0
SRC_URI="
	https://github.com/readthedocs/sphinx-autoapi/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

RDEPEND="
	>=dev-python/astroid-3.0.0[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/sphinx-7.4.0[${PYTHON_USEDEP}]
"

BDEPEND+="
	test? (
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	)
"

DOCS=( README.rst CHANGELOG.rst )

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/python/test_pyintegration.py::TestPEP695::test_integration
		tests/python/test_pyintegration.py::TestPipeUnionModule::test_integration
		"tests/test_integration.py::TestExtensionErrors::test_extension_setup_errors[dotnetexample"
	)

	distutils-r1_python_test
}
