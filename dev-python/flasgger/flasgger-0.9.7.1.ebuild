# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Easy OpenAPI specs and Swagger UI for your Flask API"
HOMEPAGE="
	https://github.com/flasgger/flasgger/
	https://pypi.org/project/flasgger/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/flask-0.10[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0.1[${PYTHON_USEDEP}]
	dev-python/mistune[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

PATCHES=(
	# https://github.com/flasgger/flasgger/pull/633
	"${FILESDIR}/${PN}-0.9.7.1-click-8.2.patch"
)

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# requires flex
		tests/test_examples.py
	)

	epytest tests
}
