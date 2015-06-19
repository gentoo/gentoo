# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/keyczar/keyczar-0.71c.ebuild,v 1.2 2015/04/08 08:05:25 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=python-${PN}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Toolkit for safe and simple cryptography"
HOMEPAGE="http://www.keyczar.org https://pypi.python.org/pypi/python-keyczar/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/pycrypto-2.0[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_test() {
	cd "${S}"/tests/keyczar_tests
	${PYTHON} alltests.py || die "tests fail with ${EPYTHON}"
}
