# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( pypy3 python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="https://www.python-ldap.org/en/latest/
	https://pypi.org/project/python-ldap/
	https://github.com/python-ldap/python-ldap"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/python-ldap/python-ldap.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
fi

LICENSE="MIT PSF-2"
SLOT="0"
IUSE="examples sasl ssl"

# < dep on openldap for bug #835637, ldap_r is gone
RDEPEND="
	>=dev-python/pyasn1-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.1.5[${PYTHON_USEDEP}]
	<net-nds/openldap-2.6:=[sasl?,ssl?]
"
# We do not link against cyrus-sasl but we use some
# of its headers during the build.
DEPEND="
	<net-nds/openldap-2.6:=[sasl?,ssl?]
	sasl? ( >=dev-libs/cyrus-sasl-2.1 )
"

distutils_enable_tests pytest
distutils_enable_sphinx Doc

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

python_test() {
	# Run all tests which don't require slapd
	local EPYTEST_IGNORE=(
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
	pushd Tests >/dev/null || die
	epytest
	popd > /dev/null || die
}

python_install() {
	distutils-r1_python_install
	python_optimize
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r Demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
