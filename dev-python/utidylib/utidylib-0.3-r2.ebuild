# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

MY_P="uTidylib-${PV}"

DESCRIPTION="TidyLib Python wrapper"
HOMEPAGE="https://cihar.com/software/utidylib/"
SRC_URI="http://dl.cihar.com/${PN}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86"
IUSE="doc test"

RDEPEND="
	app-text/tidy-html5
	dev-python/six[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

RESTRICT="test"	# 1/11 tests fail

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	if use doc; then
		${EPYTHON} setup.py build_sphinx || die
	fi
}

python_test() {
	py.test || die "testsuite failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all
}
