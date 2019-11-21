# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy{,3} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic

MY_PN=pyOpenSSL
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="
	https://www.pyopenssl.org/
	https://pypi.org/project/pyOpenSSL/
	https://github.com/pyca/pyopenssl
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.8[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
		')
	)
	test? (
		virtual/python-cffi[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.1[${PYTHON_USEDEP}]
	)"

S=${WORKDIR}/${MY_P}

python_check_deps() {
	use doc || return 0
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
		has_version "dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]"
}

python_prepare_all() {
	# Requires network access
	sed -i -e 's/test_set_default_verify_paths/_&/' tests/test_ssl.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	TZ=UTC pytest -vv || die "Testing failed with ${EPYTHON}" # Fixes bug #627530
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
