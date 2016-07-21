# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="${PN/pyw/PyW}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python module for discrete, stationary, and packet wavelet transforms"
HOMEPAGE="http://www.pybytes.com/pywavelets https://github.com/PyWavelets/pywt"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

DEPEND="
	app-arch/unzip
	dev-python/cython[${PYTHON_USEDEP}]
	test? ( dev-python/numpy[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_test() {
	# Taken form tox.ini
	"${PYTHON}" runtests.py -n -m full pywt/tests/ || die
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && local HTML_DOCS=( doc/build/html/. )
	use examples && local 	EXAMPLES=( demo/. )

	distutils-r1_python_install_all
}
