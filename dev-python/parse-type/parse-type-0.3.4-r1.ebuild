# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simplifies to build parse types based on the parse module"
HOMEPAGE="https://github.com/jenisys/parse_type"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-python/parse-1.6[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python2*' 'python3_3')"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}/${P}-python-3.5-tests-compat.patch" )

S="${WORKDIR}/${MY_P}"

python_test() {
	py.test tests || die "Tests failed under ${EPYTHON}"
}
