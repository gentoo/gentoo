# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="py.test plugin that stores test expectations by saving the set of failing tests"
HOMEPAGE="https://github.com/gsnedders/pytest-expect/ https://pypi.org/project/pytest-expect/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/u-msgpack[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
