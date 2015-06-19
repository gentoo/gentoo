# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/doublex/doublex-1.7.ebuild,v 1.1 2014/10/11 22:25:03 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Test doubles for Python"
HOMEPAGE="https://bitbucket.org/DavidVilla/python-doublex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' 'python2*')
	)
"
RDEPEND=""

python_test() {
	esetup.py test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	rm "${D}"/usr/README.rst || die "Couldn't remove spurious README.rst"
}
