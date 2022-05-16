# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{8..11} pypy3 )
inherit distutils-r1

DESCRIPTION="Cheap setup.py hack to install flit & poetry-based projects"
HOMEPAGE="https://github.com/mgorny/pyproject2setuppy"
SRC_URI="
	https://github.com/mgorny/pyproject2setuppy/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.2.3[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
