# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/radon/radon-1.2.2.ebuild,v 1.1 2015/07/19 05:25:17 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Code Metrics in Python"
HOMEPAGE="https://radon.readthedocs.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RCDEPEND="
	dev-python/mando[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
"
DEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	${CDEPEND}
	test? (
		${RCDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/paramunittest[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	${RCDEPEND}
"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" radon/tests/run.py || die "tests failed to run under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
