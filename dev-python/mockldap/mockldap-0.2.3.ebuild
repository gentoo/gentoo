# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 eutils

DESCRIPTION="A simple mock implementation of python-ldap"
HOMEPAGE="https://bitbucket.org/psagers/mockldap/ https://pypi.python.org/pypi/mockldap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="
	~dev-python/funcparserlib-0.3.6[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/python-ldap[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

# Disable un-needed d'loading during doc build
PATCHES=( "${FILESDIR}"/mapping.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "hashed password support" dev-python/passlib
}
