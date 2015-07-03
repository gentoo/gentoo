# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/setuptools_scm/setuptools_scm-1.5.4.ebuild,v 1.1 2015/07/03 14:46:29 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="package to manage versions by scm tags via setuptools"
HOMEPAGE="http://bitbucket.org/pypa/setuptools_scm/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	py.test || die "tests failed under ${EPYTHON}"
}
