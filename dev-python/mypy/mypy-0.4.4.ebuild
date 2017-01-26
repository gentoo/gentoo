# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python3_4 python3_5 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Optional static typing for Python"
HOMEPAGE="http://www.mypy-lang.org/"
SRC_URI="https://github.com/JukkaL/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="
	test? ( dev-python/flake8[${PYTHON_USEDEP}] )
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"
RDEPEND="$(python_gen_cond_dep '!dev-python/typing[${PYTHON_USEDEP}]' 'python3_3' 'python3_4')"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	local PYTHONPATH="$(pwd)"

	"${PYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
