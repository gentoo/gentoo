# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A binary plist parser/generator for Python"
HOMEPAGE="https://pypi.python.org/pypi/biplist/ https://github.com/wooster/biplist"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
IUSE="test"

LICENSE="BSD"
SLOT="0"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		${RDEPEND} )"

python_test() {
	# This failure still occurs, after 18 momths
	# https://github.com/wooster/biplist/issues/8
	nosetests || die "Tests failed under ${EPYTHON}"
}
