# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="A library for parsing ISO 8601 strings"
HOMEPAGE="https://bitbucket.org/nielsenb/aniso8601/ https://pypi.org/project/aniso8601/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" -m unittest discover ${PN}/tests || die "Tests fail with ${EPYTHON}"
}
