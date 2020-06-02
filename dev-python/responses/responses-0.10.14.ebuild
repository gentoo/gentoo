# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Utility for mocking out the Python Requests library"
HOMEPAGE="https://github.com/getsentry/responses"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	dev-python/cookies[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/responses-0.10.7-tests.patch"
)

distutils_enable_tests pytest
