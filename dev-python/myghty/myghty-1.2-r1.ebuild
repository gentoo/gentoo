# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="Myghty"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Template and view-controller framework derived from HTML::Mason"
HOMEPAGE="http://www.myghty.org/ https://pypi.python.org/pypi/Myghty"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-python/routes-1.0[${PYTHON_USEDEP}]
	dev-python/paste[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/pastescript[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	if use doc; then
		cd doc || die
		"${PYTHON}" genhtml.py || die
	fi
}

python_test() {
	"${PYTHON}" test/alltests.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		dohtml -r doc/html/.
	fi
}
