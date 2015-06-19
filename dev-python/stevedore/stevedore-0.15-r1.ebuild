# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/stevedore/stevedore-0.15-r1.ebuild,v 1.2 2014/07/06 12:50:02 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Manage dynamic plugins for Python applications"
HOMEPAGE="https://github.com/dreamhost/stevedore"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.5.21[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		test? ( dev-python/nose[${PYTHON_USEDEP}]
				dev-python/mock[${PYTHON_USEDEP}]
				dev-python/coverage[${PYTHON_USEDEP}]
				dev-python/flake8[${PYTHON_USEDEP}] )
		doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
				dev-python/pillow[${PYTHON_USEDEP}] )"

python_compile_all() {
	if use doc; then
		mkdir docs/source/_build || die
		sphinx-build -b html -c docs/source docs/source/ docs/source/_build
	fi
}

python_test() {
	nosetests -d --with-coverage --cover-inclusive --cover-package stevedore \
		|| die "Tests failed under ${EPYTHON}"
	flake8 stevedore setup.py || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/source/_build/. )
	distutils-r1_python_install_all
}
