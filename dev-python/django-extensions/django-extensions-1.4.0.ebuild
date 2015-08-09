# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

GIT_HASH_TAG="32ffe9b"

DESCRIPTION="Django Command Extensions"
HOMEPAGE="http://github.com/django-extensions/django-extensions http://code.google.com/p/django-command-extensions/"
SRC_URI="http://github.com/django-extensions/django-extensions/tarball/${PV}/${P}.tgz"

LICENSE="BSD || ( MIT GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc graphviz s3 test vcard"
# Req'd for tests
DISTUTILS_IN_SOURCE_BUILD=1

PY2_USEDEP=$(python_gen_usedep 'python2*')
RDEPEND=">=dev-python/django-1.5.4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	graphviz? ( dev-python/pygraphviz[${PY2_USEDEP}] )
	s3? ( dev-python/boto[${PY2_USEDEP}] )
	vcard? ( dev-python/vobject[${PY2_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND}
		dev-python/shortuuid[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${PN}-${PN}-${GIT_HASH_TAG}"

PY2_REQUSE="|| ( $(python_gen_useflags python2* ) )"
REQUIRED_USE="
	graphviz? ( ${PY2_REQUSE} )
	s3? ( ${PY2_REQUSE} )
	vcard? ( ${PY2_REQUSE} )"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" run_tests.py || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
