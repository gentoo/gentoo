# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="Routes"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python re-implementation of Rails routes system, mapping URL's to Controllers/Actions"
HOMEPAGE="http://routes.groovie.org http://pypi.python.org/pypi/Routes"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc test"

RDEPEND=">=dev-python/repoze-lru-0.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
	)"
# It appears there's an epidemic of missing testsuites coming out of github. Restrict for now
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

# Comment out patch for tests for now
#PATCHES=( "${FILESDIR}"/${PN}-2.0-tests-py3.patch )

# https://github.com/bbangert/routes/issues/42 presents a patch 
# for the faulty docbuild converted to sed stmnts
python_prepare_all() {
	use test && DISTUTILS_IN_SOURCE_BUILD=1
	# The default theme in sphinx switched to classic from shpinx-1.3.1
	if has_version ">=dev-python/sphinx-1.3.1"; then
		sed -e "s:html_theme_options = {:html_theme = 'classic'\n&:" \
			-i docs/conf.py || die
	else
		sed -e "s:html_theme_options = {:html_theme = 'default'\n&:" \
			-i docs/conf.py || die
	fi
	sed -e "s:changes:changes\n   todo:" \
		-i docs/index.rst || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cp -r tests "${BUILD_DIR}" || die
	if [[ ${EPYTHON} == python3* ]]; then
		2to3 -w --no-diffs "${BUILD_DIR}"/tests || die
	fi

	nosetests -w "${BUILD_DIR}"/tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
