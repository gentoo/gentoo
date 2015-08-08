# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Command line twitter client"
HOMEPAGE="https://github.com/alejandrogomez/turses"
SRC_URI="https://github.com/alejandrogomez/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	>dev-python/tweepy-2.2[${PYTHON_USEDEP}]
	<dev-python/tweepy-3[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	use doc && emake -C docs html
	emake -C docs man
}

python_test() {
	py.test tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	doman "docs/_build/man/turses.1"
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
