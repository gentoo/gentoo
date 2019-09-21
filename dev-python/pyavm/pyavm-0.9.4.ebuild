# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1

MYPN=PyAVM
MYP=${MYPN}-${PV}

DESCRIPTION="Python module for Astronomy Visualization Metadata i/o"
HOMEPAGE="http://astrofrog.github.io/pyavm/"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/astropy[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/astropy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MYP}"

python_test() {
	py.test || die "tests for ${EPYTHON} failed"
}
