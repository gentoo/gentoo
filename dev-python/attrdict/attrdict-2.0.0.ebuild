# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/attrdict/attrdict-2.0.0.ebuild,v 1.1 2015/07/29 19:14:30 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="A dict with attribute-style access"
HOMEPAGE="https://github.com/bcj/AttrDict"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		>=dev-python/nose-1.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

python_test() {
	esetup.py nosetests || die "tests failed under ${EPYTHON}"
}
