# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 vcs-snapshot

MY_PN="PyDispatcher"

DESCRIPTION="Multi-producer-multi-consumer signal dispatching mechanism"
HOMEPAGE="http://pydispatcher.sourceforge.net/ https://pypi.python.org/pypi/PyDispatcher"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="doc examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_compile_all() {
	if use doc; then
		pushd docs/pydoc/ > /dev/null
		"${PYTHON}" builddocs.py || die "Generation of documentation failed"
		popd > /dev/null
	fi
}

python_test() {
	"${PYTHON}" -m unittest discover
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/pydoc/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
