# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit distutils-r1 flag-o-matic

MY_PN="pyOpenSSL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="http://pyopenssl.sourceforge.net/ https://launchpad.net/pyopenssl http://pypi.python.org/pypi/pyOpenSSL"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="doc"

RDEPEND=">=dev-libs/openssl-0.9.6g"
DEPEND="${RDEPEND}
	doc? ( >=dev-tex/latex2html-2002.2[gif,png] )"

# pypy* won't fit since CPython 3 is 'better' than it
REQUIRED_USE="doc? ( || ( $(python_gen_useflags python2*) ) )"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	sed \
		-e "s/test_set_tlsext_host_name_wrong_args/_&/" \
		-i OpenSSL/test/test_ssl.py || die "test_ssl sed failed"

	distutils-r1_python_prepare_all
}

python_compile() {
	local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}
	[[ ${EPYTHON} != python3* ]] && append-flags -fno-strict-aliasing

	distutils-r1_python_compile
}

python_compile_all() {
	if use doc; then
		addwrite /var/cache/fonts

		cd doc || die
		emake -j1 html ps dvi
	fi
}

python_test() {
	cd "${BUILD_DIR}"/lib/OpenSSL/test || die

	local t
	for t in test_*.py; do
		"${PYTHON}" "${t}" || die "Test ${t} fails with ${EPYTHON}"
	done
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		dohtml -r doc/html/.
		dodoc doc/pyOpenSSL.*
	fi

	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
