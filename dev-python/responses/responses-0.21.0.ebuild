# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Utility for mocking out the Python Requests library"
HOMEPAGE="
	https://pypi.org/project/responses/
	https://github.com/getsentry/responses/
"
SRC_URI="
	https://github.com/getsentry/responses/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	<dev-python/requests-3[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.10[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
