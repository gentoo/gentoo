# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

MY_PN="PasteScript"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A pluggable command-line frontend, including commands to setup package file layouts"
HOMEPAGE="http://pythonpaste.org/script/ http://pypi.python.org/pypi/PasteScript"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc test"

RDEPEND="
	>=dev-python/paste-1.3[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? (
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		)
	test? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

# Tests are broken.
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	if use doc; then
		einfo "Generation of documentation"
		esetup.py build_sphinx
	fi
}

python_test() {
	nosetests -v -v || die
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		cd "${BUILD_DIR}"/sphinx/html || die
		dohtml -r [a-z]* _static
	fi
}
