# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN="WSGIProxy2"

DESCRIPTION="HTTP proxying tools for WSGI apps"
HOMEPAGE="https://pypi.org/project/WSGIProxy2/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/webob[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		>=dev-python/webtest-2.0.17[${PYTHON_USEDEP}]
		dev-python/socketpool[${PYTHON_USEDEP}]
		dev-python/restkit[$(python_gen_usedep python2_7)] )"
# Tests needing restkit are skipped under py3
# Testing also revealed the suite needs latest webtest

S="${WORKDIR}/${MY_PN}-${PV}"

python_compile_all() {
	if use doc; then
		cd docs || die
		sphinx-build -b html -d _build/doctrees   . _build/html
	fi
}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
