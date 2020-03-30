# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_P="TPG-${PV}"

DESCRIPTION="Toy Parser Generator for Python"
HOMEPAGE="http://christophe.delord.free.fr/tpg/index.html"
SRC_URI="http://christophe.delord.free.fr/tpg/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86"
IUSE="doc examples"
DOCS=( ChangeLog README THANKS doc/tpg.pdf )

S="${WORKDIR}/${MY_P}"

python_test() {
	"${PYTHON}" tpg_tests.py -v || die
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
