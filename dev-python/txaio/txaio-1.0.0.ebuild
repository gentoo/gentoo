# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="a helper library for writing code unmodified on both Twisted and asyncio"
HOMEPAGE="https://github.com/tavendo/txaio"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/pep8-1.6.2[${PYTHON_USEDEP}]"

DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}] )
	test? ( >=dev-python/pytest-2.6.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-1.8.1[${PYTHON_USEDEP}] )"

python_prepare() {
	# https://github.com/tavendo/txaio/issues/3
	cp -r "${FILESDIR}"/util.py test || die

	distutils-r1_python_prepare
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	py.test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
