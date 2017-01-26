# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="nose2 is the next generation of nicer testing for Python"
HOMEPAGE="https://github.com/nose-devs/nose2"
SRC_URI="https://github.com/nose-devs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

CDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.1[${PYTHON_USEDEP}]
"
DEPEND="
	${CDEPEND}
	doc? ( >=dev-python/sphinx-1.0.5[${PYTHON_USEDEP}] )
"
RDEPEND="
	${CDEPEND}
	>=dev-python/cov-core-1.12[${PYTHON_USEDEP}]
"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" -m nose2.__main__ || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
