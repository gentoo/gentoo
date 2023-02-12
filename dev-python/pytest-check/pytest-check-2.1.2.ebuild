# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="pytest plugin that allows multiple failures per test"
HOMEPAGE="
	https://github.com/okken/pytest-check/
	https://pypi.org/project/pytest-check/
"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
