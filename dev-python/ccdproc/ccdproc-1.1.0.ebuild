# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5} )

inherit distutils-r1

DESCRIPTION="Astropy affiliated package for reducing optical/IR CCD data"
HOMEPAGE="https://github.com/astropy/ccdproc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD"
SLOT="0"
IUSE="doc test"

DOCS=( README.rst )

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
			dev-python/astroscrappy[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/reproject[${PYTHON_USEDEP}]
		  )"

python_prepare_all() {
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
