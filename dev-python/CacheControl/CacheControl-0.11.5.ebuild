# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="The httplib2 caching algorithms packaged up for use with requests"
HOMEPAGE="https://github.com/ionrock/cachecontrol https://pypi.python.org/pypi/cachecontrol/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc64 ~sparc ~x86"
IUSE="redis test"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/lockfile-0.9[${PYTHON_USEDEP}]
	redis? ( dev-python/redis-py[${PYTHON_USEDEP}] )"
DEPENDS="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}]	)
"

python_test() {
	py.test -v || die
}
