# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A CLI and set of pre-commit hooks for jsonschema validation"
HOMEPAGE="
	https://pypi.org/project/check-jsonschema/
	https://github.com/python-jsonschema/check-jsonschema
"
SRC_URI="https://github.com/python-jsonschema/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/ruamel-yaml-0.18.10[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4.18.0[${PYTHON_USEDEP}]
	>=dev-python/regress-2024.11.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/click-8[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		>=dev-python/responses-0.25.7[${PYTHON_USEDEP}]
		>=dev-python/identify-2.6.9[${PYTHON_USEDEP}]
	)
"

DOCS=(
	README.md
	CONTRIBUTING.md
	CHANGELOG.rst
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-issues \
	dev-python/furo
