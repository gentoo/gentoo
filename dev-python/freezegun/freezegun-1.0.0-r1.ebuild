# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Let your Python tests travel through time"
HOMEPAGE="https://github.com/spulec/freezegun"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>dev-python/python-dateutil-2.7[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
