# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 flag-o-matic

MY_PN="python-glyr"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A python wrapper for Glyr"
HOMEPAGE="https://sahib.github.com/python-glyr/intro.html
	https://github.com/sahib/python-glyr"
SRC_URI="https://github.com/sahib/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="doc"

RDEPEND="media-libs/glyr"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Disable test requiring internet connection
	sed -e 's:test_download:_&:' -i tests/test_misc.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		emake -C docs html || die "Generating documentation failed"
	fi
}

python_test() {
	"${PYTHON}" -m unittest discover tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
