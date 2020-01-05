# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1 eutils

DESCRIPTION="A simple mock implementation of python-ldap"
HOMEPAGE="https://bitbucket.org/psagers/mockldap/ https://pypi.org/project/mockldap/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	~dev-python/funcparserlib-0.3.6[${PYTHON_USEDEP}]
	virtual/python-unittest-mock[${PYTHON_USEDEP}]
	>=dev-python/python-ldap-3.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

# Tests are not distributed as part of the release
RESTRICT="test"

# Disable un-needed d'loading during doc build
# Import python-ldap 3.0 instead as a requirement from upstream
PATCHES=( "${FILESDIR}"/mapping.patch "${FILESDIR}"/python-ldap-3.patch )

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
