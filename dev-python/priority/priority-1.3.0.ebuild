# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9})

inherit distutils-r1

DESCRIPTION="A pure-Python implementation of the HTTP/2 priority tree"
HOMEPAGE="https://python-hyper.org/priority/en/latest/
	https://github.com/python-hyper/priority
	https://pypi.org/project/priority/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"

DEPEND="
	test? ( >=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/priority-1.3.0-test-timeout.patch
)

distutils_enable_tests pytest
