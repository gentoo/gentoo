# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/keyring/keyring-4.0.ebuild,v 1.1 2014/12/06 11:37:37 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="https://bitbucket.org/kang/python-keyring-lib"
SRC_URI="mirror://pypi/k/${PN}/${P}.zip"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pycrypto[$(python_gen_usedep 'python2*' 'python3*')]
		)"
RDEPEND=""

python_test() {
	py.test || die "testsuite failed under ${EPYTHON}"
}
