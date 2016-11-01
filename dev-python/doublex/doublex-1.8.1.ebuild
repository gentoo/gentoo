# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python test doubles"
HOMEPAGE="https://bitbucket.org/DavidVilla/python-doublex"
SRC_URI="https://bitbucket.org/DavidVilla/python-${PN}/get/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

CDEPEND="dev-python/pyhamcrest[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/unittest2[${PYTHON_USEDEP}]' 'python2*')
	)
"
RDEPEND="${CDEPEND}"

python_compile_all() {
	use doc && emake -C docs
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all

	rm "${ED}"/usr/README.rst || die "Couldn't remove spurious README.rst"
}
