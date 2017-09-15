# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

MY_PN=python-${PN}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python library for the snappy compression library from Google"
HOMEPAGE="https://pypi.python.org/pypi/python-snappy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 arm x86"
SLOT="0"

DEPEND=">=app-arch/snappy-1.0.2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

python_test() {
	"${PYTHON}" test_snappy.py -v || die "Tests fail with ${EPYTHON}"
}
