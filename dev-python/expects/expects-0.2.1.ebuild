# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/expects/expects-0.2.1.ebuild,v 1.2 2014/10/18 14:45:35 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Expressive and extensible TDD/BDD assertion library for Python"
HOMEPAGE="https://github.com/jaimegildesagredo/expects"
SRC_URI="https://github.com/jaimegildesagredo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ~dev-python/mamba-0.6[${PYTHON_USEDEP}] )
"
RDEPEND=""

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	local DISTUTILS_NO_PARALLEL_BUILD=TRUE

	rm -f "${HOME}"/.pydistutils.cfg || die "Couldn't remove pydistutils.cfg"

	distutils_install_for_testing

	mamba || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
