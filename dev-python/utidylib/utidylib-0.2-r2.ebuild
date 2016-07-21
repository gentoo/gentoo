# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="uTidylib-${PV}"

DESCRIPTION="TidyLib Python wrapper"
HOMEPAGE="http://sourceforge.net/projects/utidylib/"
#SRC_URI="mirror://berlios/${PN}/${MY_P}.zip"
SRC_URI="mirror://gentoo/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc test"

RDEPEND="app-text/htmltidy"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )
	test? ( dev-python/twisted-core[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}-no-docs-in-site-packages.patch"
		"${FILESDIR}/${P}-fix_tests.patch"
	)

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		"${PYTHON}" gendoc.py || die
	fi
}

python_test() {
	trial tidy || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( apidoc/. )
	distutils-r1_python_install_all
}
