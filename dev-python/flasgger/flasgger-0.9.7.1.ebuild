# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Easy OpenAPI specs and Swagger UI for your Flask API"
HOMEPAGE="
	https://github.com/flasgger/flasgger/
	https://pypi.org/project/flasgger/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~riscv ~s390 ~sparc"

RDEPEND="
	>=dev-python/flask-0.10[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0.1[${PYTHON_USEDEP}]
	dev-python/mistune[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# requires flex
		tests/test_examples.py
	)

	epytest tests
}
