# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Read resources from Python packages"
HOMEPAGE="https://importlib-resources.readthedocs.io/en/latest/"
SRC_URI="https://gitlab.com/python-devs/${PN}/-/archive/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}"

python_test() {
	esetup.py test
}
