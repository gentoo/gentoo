# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Let your Python tests travel through time"
HOMEPAGE="
	https://github.com/spulec/freezegun/
	https://pypi.org/project/freezegun/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>dev-python/python-dateutil-2.7[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
