# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

GITHUB_P=${P,,}
DESCRIPTION="A utility class for manipulating URLs"
HOMEPAGE="https://pypi.python.org/pypi/URLObject"
# note: pypi tarball lacks tests
# https://github.com/zacharyvoase/urlobject/issues/39
SRC_URI="https://github.com/zacharyvoase/urlobject/archive/v${PV}.tar.gz -> ${GITHUB_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

S=${WORKDIR}/${GITHUB_P}

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
