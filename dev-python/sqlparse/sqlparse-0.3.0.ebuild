# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1

DESCRIPTION="A non-validating SQL parser module for Python"
HOMEPAGE="https://github.com/andialbrecht/sqlparse"
SRC_URI="https://github.com/andialbrecht/sqlparse/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="${DEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest )"

python_test() {
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
