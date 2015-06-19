# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-ldap/python-ldap-9999.ebuild,v 1.7 2015/04/08 08:05:10 mgorny Exp $

EAPI=5

# pypy: bug #458558 (wrong linker options due to not respecting CC)
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1
DISTUTILS_NO_PARALLEL_BUILD=1

inherit distutils-r1 git-2 multilib

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="http://www.python-ldap.org http://pypi.python.org/pypi/python-ldap"
EGIT_REPO_URI="https://github.com/xmw/python-ldap.git"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS=""
IUSE="doc examples sasl ssl"

# If you need support for openldap-2.3.x, please use python-ldap-2.3.9.
# python team: Please do not remove python-ldap-2.3.9 from the tree.
RDEPEND=">=net-nds/openldap-2.4
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sasl? ( >=dev-libs/cyrus-sasl-2.1 )"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}] )"

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

python_compile_all() {
	use doc && emake -C Doc html
}

python_test() {
	# XXX: the tests supposedly can start local slapd
	# but it requires some manual config, it seems.

	"${PYTHON}" Tests/t_ldapurl.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( Demo/. )
	use doc && local HTML_DOCS=( Doc/.build/html/. )

	distutils-r1_python_install_all
}
