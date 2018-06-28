# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Test utilities for code working with files and commands"
HOMEPAGE="http://jupyter.org"
SRC_URI="https://github.com/jupyter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ppc64 x86"
IUSE="doc test"

DEPEND="
	test? (
		dev-python/pathlib2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-0.2-setup.py.patch )

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i doc/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C doc html
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp -r "${S}"/tests "${TEST_DIR}"/lib/ || die
	py.test || die
}
