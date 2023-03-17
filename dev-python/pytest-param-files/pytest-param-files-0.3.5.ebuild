# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Pytest parametrize decorators from external files."
HOMEPAGE="
	https://github.com/chrisjsewell/pytest-param-files/
	https://pypi.org/project/pytest_param_files/
"
SRC_URI="
	https://github.com/chrisjsewell/pytest-param-files/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
