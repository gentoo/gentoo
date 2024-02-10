# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="
	https://www.python-ldap.org/en/latest/
	https://pypi.org/project/python-ldap/
	https://github.com/python-ldap/python-ldap/
"
SRC_URI="
	https://github.com/python-ldap/python-ldap/archive/${P}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${PN}-${P}

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv sparc x86"
IUSE="examples sasl ssl"

RDEPEND="
	>=dev-python/pyasn1-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.1.5[${PYTHON_USEDEP}]
	net-nds/openldap:=[sasl?,ssl?]
"
# We do not link against cyrus-sasl but we use some
# of its headers during the build.
DEPEND="
	net-nds/openldap:=[sasl?,ssl?]
	sasl? ( >=dev-libs/cyrus-sasl-2.1 )
"

distutils_enable_tests pytest
distutils_enable_sphinx Doc

python_prepare_all() {
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

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r Demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
