# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Extract data from Python tracebacks for informative displays"
HOMEPAGE="
	https://github.com/alexmojaki/stack_data/
	https://pypi.org/project/stack-data/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/asttokens[${PYTHON_USEDEP}]
	dev-python/executing[${PYTHON_USEDEP}]
	dev-python/pure_eval[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/typeguard[${PYTHON_USEDEP}]
		dev-python/littleutils[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
