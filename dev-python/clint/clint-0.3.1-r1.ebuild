# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python Command-line Application Tools"
HOMEPAGE="https://github.com/kennethreitz/clint"
SRC_URI="https://github.com/kennethreitz/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples test"

DEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
RDEPEND=""

# Prevent install of files to wrong location
PATCHES=( "${FILESDIR}"/${PN}-setup.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
