# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

MY_PN="${PN/pyw/PyW}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Discrete Wavelet Transforms in Python"
HOMEPAGE="https://pywavelets.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}] )
	test? (
	   ${RDEPEND}
	   dev-python/nose[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_P}"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	nosetests -v .
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r demo/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
