# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A new approach to API documentation in Sphinx"
HOMEPAGE="
	https://sphinx-autoapi.readthedocs.io/
	https://github.com/readthedocs/sphinx-autoapi/
	https://pypi.org/project/sphinx-autoapi/
"
SRC_URI="
	https://github.com/readthedocs/sphinx-autoapi/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

RDEPEND="
	dev-python/astroid[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/sphinx-4.0[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
"

DOCS=( README.rst CHANGELOG.rst )

# Test requires pypi download w/ internet: https://github.com/readthedocs/sphinx-autoapi/issues/329
EPYTEST_DESELECT=(
	tests/test_integration.py::TestExtensionErrors::test_extension_setup_errors[dotnetexample-override_conf2-AutoAPI
)

distutils_enable_tests pytest
distutils_enable_sphinx docs --no-autodoc
