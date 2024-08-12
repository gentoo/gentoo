# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="Resolve abstract dependencies into concrete ones"
HOMEPAGE="
	https://github.com/sarugaku/resolvelib/
	https://pypi.org/project/resolvelib/

"
SRC_URI="
	https://github.com/sarugaku/resolvelib/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ppc ppc64 ~riscv ~sparc x86"

BDEPEND="
	test? (
		dev-python/commentjson[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
