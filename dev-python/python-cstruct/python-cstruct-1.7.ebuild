# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN=${PN#python-}
MY_P=${MY_PN}-${PV}
DESCRIPTION="C-style structs for Python"
HOMEPAGE="https://github.com/andreax79/python-cstruct https://pypi.org/project/cstruct/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
S=${WORKDIR}/${MY_P}

DOCS=( README.md )

python_test() {
	esetup.py test || die "tests failed under ${EPYTHON}"
}
