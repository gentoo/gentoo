# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 multilib

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="https://www.python-ldap.org/en/latest/
	https://pypi.org/project/python-ldap"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-solaris"
IUSE="examples sasl ssl"

# If you need support for openldap-2.3.x, please use python-ldap-2.3.9.
# python team: Please do not remove python-ldap-2.3.9 from the tree.
# OpenSSL is an optional runtime dep.
# setup.py sets setuptools and misses pyasn1 and pyasn1-modules in install_requires
RDEPEND=">net-nds/openldap-2.4.11
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	sasl? ( >=dev-libs/cyrus-sasl-2.1 )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND+=" !dev-python/pyldap"

python_prepare_all() {
	sed -e "s:^library_dirs =.*:library_dirs = /usr/$(get_libdir) /usr/$(get_libdir)/sasl2:" \
		-e "s:^include_dirs =.*:include_dirs = ${EPREFIX}/usr/include ${EPREFIX}/usr/include/sasl:" \
		-i setup.cfg || die "error fixing setup.cfg"

	local mylibs="ldap"
	if use sasl; then
		use ssl && mylibs="ldap_r"
		mylibs="${mylibs} sasl2"
	else
		sed -e 's/HAVE_SASL//g' -i setup.cfg || die
	fi
	use ssl && mylibs="${mylibs} ssl crypto"
	use elibc_glibc && mylibs="${mylibs} resolv"

	sed -e "s:^libs = .*:libs = lber ${mylibs}:" \
		-i setup.cfg || die "error setting up libs in setup.cfg"

	# set test expected to fail to expectedFailure
	sed -e "s:^    def test_bad_urls:    @unittest.expectedFailure\n    def test_bad_urls:" \
		-i Tests/t_ldapurl.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# XXX: the tests supposedly can start local slapd
	# but it requires some manual config, it seems.

	"${PYTHON}" Tests/t_ldapurl.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( Demo/. )

	distutils-r1_python_install_all
}
