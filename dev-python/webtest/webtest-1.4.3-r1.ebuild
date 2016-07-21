# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

MY_PN="WebTest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Helper to test WSGI applications"
HOMEPAGE="http://pythonpaste.org/webtest/ https://pypi.python.org/pypi/WebTest"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=dev-python/webob-0.9.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyquery[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"
PATCHES=( "${FILESDIR}/webtest-1.4.3-doctest.patch" )

python_compile_all() {
	if use doc; then
		sphinx-build docs html || die
	fi
}

python_test() {
	# Tests raise ImportErrors with our default PYTHONPATH.
	unset PYTHONPATH
	nosetests || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	if [[ ${EPYTHON} == python3* ]]; then
		rm -f "${D}$(python_get_sitedir)"/webtest/lint3.py
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( html/. )
	distutils-r1_python_install_all
}
