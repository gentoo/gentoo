# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Identity management for flask"
HOMEPAGE="https://pythonhosted.org/Flask-Principal/ https://pypi.org/project/Flask-Principal/"
SRC_URI="https://github.com/mattupstate/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
# pypi tarball is missing tests

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	nosetests -v || die "Testing failed with ${EPYTHON}"
}
