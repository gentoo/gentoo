# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

EGIT_REPO_URI="https://github.com/mgorny/gentoopm.git"
inherit distutils-r1 git-r3

DESCRIPTION="A common interface to Gentoo package managers"
HOMEPAGE="https://github.com/mgorny/gentoopm/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	|| (
		>=sys-apps/pkgcore-0.9.4[${PYTHON_USEDEP}]
		>=sys-apps/portage-2.1.10.3[${PYTHON_USEDEP}]
		>=sys-apps/paludis-3.0.0_pre20170219[python,${PYTHON_USEDEP}] )"
DEPEND="doc? ( dev-python/epydoc[$(python_gen_usedep python2_7)] )"
PDEPEND="app-eselect/eselect-package-manager"

REQUIRED_USE="doc? ( $(python_gen_useflags python2_7) )"

src_configure() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( python2_7 )
	distutils-r1_src_configure
}

python_compile_all() {
	use doc && esetup.py doc
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )

	distutils-r1_python_install_all
}
