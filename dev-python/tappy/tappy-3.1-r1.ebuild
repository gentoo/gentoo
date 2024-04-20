# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN="tap.py"
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Test Anything Protocol (TAP) tools"
HOMEPAGE="
	https://github.com/python-tap/tappy/
	https://pypi.org/project/tap.py/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	test? (
		dev-python/more-itertools[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
distutils_enable_sphinx docs

pkg_postinst() {
	optfeature "YAML blocks associated with test results" \
		"dev-python/more-itertools dev-python/pyyaml"
}
