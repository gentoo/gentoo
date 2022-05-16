# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
inherit distutils-r1

DESCRIPTION="A library to multiply test cases"
HOMEPAGE="
	https://pypi.org/project/ddt/
	https://github.com/datadriventests/ddt/"
SRC_URI="
	https://github.com/datadriventests/ddt/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
