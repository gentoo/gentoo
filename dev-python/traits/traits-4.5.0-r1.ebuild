# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Explicitly typed attributes for Python"
HOMEPAGE="http://code.enthought.com/projects/traits/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

python_prepare() {
	if python_is_python3; then
		einfo "Converting tests to Python 3 syntax"
		2to3 -w -n --no-diffs traits/testing || die
	fi
}

python_prepare_all() {
	sed -i -e "s/'-O3'//g" setup.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	nosetests || die
}
