# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

DESCRIPTION="Friendlier RFC 6265-compliant cookie parser/renderer"
HOMEPAGE="https://gitlab.com/sashahart/cookies"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	# https://gitlab.com/sashahart/cookies/merge_requests/2
	"${FILESDIR}/cookies-2.2.1-fix-warnings.patch"

	"${FILESDIR}/cookies-2.2.1-tests.patch"
)

distutils_enable_tests pytest
