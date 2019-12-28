# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Pythonic library to create text UIs and ASCII art animations"
HOMEPAGE="https://github.com/peterbrittain/asciimatics"
SRC_URI="https://github.com/peterbrittain/asciimatics/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
	dev-python/pyfiglet[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

src_prepare() {
	sed -i -e "s/use_scm_version.*/version='${PV}',/g;" setup.py || die
	distutils-r1_src_prepare
}

python_compile_all() {
	if use doc; then
		sed -i -e 's/base_version = .*//g;' doc/source/conf.py || die
		sed -i -e 's/release = .*//g;' doc/source/conf.py || die
		sed -i -e 's/version = .*//g;' doc/source/conf.py || die
		sphinx-build -b html doc/source doc/_build/ || die
		HTML_DOCS=( doc/_build/. )
	fi
}

python_install_all() {
	use examples && dodoc -r samples
	distutils-r1_python_install_all
}
