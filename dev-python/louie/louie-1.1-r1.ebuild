# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Signal dispatching mechanism for Python"
HOMEPAGE="https://pypi.org/project/Louie/"
SRC_URI="mirror://pypi/L/${PN^}/${P^}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND=""

S="${WORKDIR}/${P^}"

python_prepare_all() {
	sed -e "/'nose >= 0.8.3'/d" -i setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
