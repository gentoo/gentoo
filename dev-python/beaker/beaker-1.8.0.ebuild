# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

MY_PN="Beaker"

DESCRIPTION="A Session and Caching library with WSGI Middleware"
HOMEPAGE="https://github.com/bbangert/beaker https://pypi.python.org/pypi/Beaker"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

# webtest-based tests are skipped when webtest is not installed
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

# Py2.7 fais some tests without this
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Workaround for http://bugs.python.org/issue11276.
	sed -e "s/import anydbm/& as anydbm/;/import anydbm/a dbm = anydbm" \
		-i beaker/container.py || die

	distutils-r1_python_prepare_all
}

pkg_postinst() {
	elog "beaker also has optional support for packages"
	elog "pycrypto and pycryptopp"
}
