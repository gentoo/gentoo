# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="Pympler"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Memory profiling for Python applications"
HOMEPAGE="http://code.google.com/p/pympler/ https://pypi.python.org/pypi/Pympler https://github.com/pympler/pympler"
SRC_URI="mirror://pypi/P/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="dev-python/bottle[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND} )"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	rm pympler/util/bottle.py || die
	sed \
		-e '/import bottle/s:^.*$:import bottle:g' \
		-i pympler/web.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py try
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}
