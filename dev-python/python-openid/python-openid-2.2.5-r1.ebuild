# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-openid/python-openid-2.2.5-r1.ebuild,v 1.10 2015/04/08 08:05:19 mgorny Exp $

EAPI=5

PYTHON_REQ_USE='sqlite?'
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="OpenID support for servers and consumers"
HOMEPAGE="http://www.openidenabled.com/openid/libraries/python/ http://pypi.python.org/pypi/python-openid"
# Downloaded from http://github.com/openid/python-openid/downloads
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="examples mysql postgres sqlite test"

RDEPEND="mysql? ( >=dev-python/mysql-python-1.2.2[${PYTHON_USEDEP}] )
	postgres? ( dev-python/psycopg[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( dev-python/twill
		dev-python/pycurl )"
S="${WORKDIR}/openid-python-openid-b666238"

python_prepare_all() {
	local PATCHES=(
		# Patch to fix confusion with localhost/127.0.0.1
		"${FILESDIR}/${PN}-2.0.0-gentoo-test_fetchers.diff"
	)

	# Disable broken tests from from examples/djopenid.
	# Remove test that requires running db server.
	sed -e "s/django_failures =.*/django_failures = 0/" \
		-e '/storetest/d' \
		-i admin/runtests || die "sed admin/runtests failed"

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" admin/runtests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
