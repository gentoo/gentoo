# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python interface to PROJ.4 library"
HOMEPAGE="https://github.com/jswhit/pyproj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	distutils-r1_python_prepare_all
	append-cflags -fno-strict-aliasing
}

python_test() {
	"${EPYTHON}" unittest/test.py || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
