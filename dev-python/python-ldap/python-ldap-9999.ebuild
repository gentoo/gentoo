# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="https://www.python-ldap.org/en/latest/
	https://pypi.org/project/python-ldap/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/python-ldap/python-ldap.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
fi

LICENSE="PSF-2"
SLOT="0"
IUSE="doc examples sasl ssl test"
RESTRICT="!test? ( test )"

# We do not need OpenSSL, it is never directly used:
# https://github.com/python-ldap/python-ldap/issues/224
RDEPEND="
	!dev-python/pyldap
	>=dev-python/pyasn1-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.1.5[${PYTHON_USEDEP}]
	>net-nds/openldap-2.4.11:=[sasl?,ssl?]
"
# We do not link against cyrus-sasl but we use some
# of its headers during the build.
DEPEND="
	>net-nds/openldap-2.4.11:=[sasl?,ssl?]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	sasl? ( >=dev-libs/cyrus-sasl-2.1 )
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# The live ebuild won't compile if setuptools_scm < 1.16.2 is installed
	# https://github.com/pypa/setuptools_scm/issues/228
	if [[ ${PV} == *9999* ]]; then
		rm -r .git || die
	fi

	if ! use sasl; then
		sed -i 's/HAVE_SASL//g' setup.cfg || die
	fi
	if ! use ssl; then
		sed -i 's/HAVE_TLS//g' setup.cfg || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build Doc Doc/_build/html || die
		HTML_DOCS=( Doc/_build/html/. )
	fi
}

python_test() {
	# Run all tests which don't require slapd
	local ignored_tests=(
		t_bind.py
		t_cext.py
		t_edit.py
		t_ldapobject.py
		t_ldap_options.py
		t_ldap_sasl.py
		t_ldap_schema_subentry.py
		t_ldap_syncrepl.py
		t_slapdobject.py
	)
	cd Tests || die
	py.test	${ignored_tests[@]/#/--ignore } \
		|| die "tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r Demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
