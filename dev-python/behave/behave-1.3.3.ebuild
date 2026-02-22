# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="BDD, Python style"
HOMEPAGE="
	https://github.com/behave/behave/
	https://pypi.org/project/behave/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/colorama-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/cucumber-expressions-17.1.0[${PYTHON_USEDEP}]
	>=dev-python/cucumber-tag-expressions-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/parse-1.18.0[${PYTHON_USEDEP}]
	>=dev-python/parse-type-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		>=dev-python/assertpy-1.1[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		>=dev-python/freezegun-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/mock-4.0[${PYTHON_USEDEP}]
		>=dev-python/path-13.1.0[${PYTHON_USEDEP}]
		>=dev-python/pyhamcrest-2.0.2[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# avoid pytest-html options
	epytest -o addopts=
}
