# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="namespace control and lazy-import mechanism"
HOMEPAGE="https://pypi.python.org/pypi/apipkg"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# https://bitbucket.org/hpk42/apipkg/issue/5/test-failure-with-python-34
	sed -e 's:test_initpkg_not_transfers_not_existing_attrs:_&:' -i test_apipkg.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	# Bug 530388. The test requires patching to match py3.4; trivial.
	py.test || die "Tests fail under ${EPYTHON}"
}
