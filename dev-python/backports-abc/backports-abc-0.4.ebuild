# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy pypy3 )

inherit distutils-r1

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Backport of Python 3.5's 'collections.abc' module"
HOMEPAGE="https://github.com/cython/backports_abc https://pypi.org/project/backports_abc/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

S=${WORKDIR}/${MY_P}

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib" "${PYTHON}" tests.py || die "tests failed with ${EPYTHON}"
}
