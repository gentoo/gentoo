# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A library to manipulate gettext files (.po and .mo files)"
HOMEPAGE="https://bitbucket.org/izi/polib/wiki/Home"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="doc"

DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" tests/tests.py || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	local DOCS=( CHANGELOG README.rst )
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
