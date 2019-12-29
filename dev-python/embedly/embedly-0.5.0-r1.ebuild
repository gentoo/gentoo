# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

MY_PN="Embedly"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Library for Embedly"
HOMEPAGE="https://github.com/embedly/embedly-python/ https://pypi.org/project/Embedly/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
# Testsuite relies upon connection to various sites on the net
RESTRICT="test"

RDEPEND="dev-python/httplib2[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_test() {
	esetup.py test
}
