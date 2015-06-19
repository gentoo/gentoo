# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/feedgenerator/feedgenerator-1.6.ebuild,v 1.4 2015/04/08 08:04:59 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} pypy )
inherit distutils-r1

DESCRIPTION="Standalone version of django.utils.feedgenerator"
HOMEPAGE="http://pypi.python.org/pypi/feedgenerator"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/six[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}] )"
RDEPEND=""

src_prepare() {
	distutils-r1_src_prepare
	# Allow pypy to read MANIFEST.in
	ln -s tests_feedgenerator tests || die
}

python_test() {
	"${PYTHON}" setup.py test
}
