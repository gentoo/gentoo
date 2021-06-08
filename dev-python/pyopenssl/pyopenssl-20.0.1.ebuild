# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 flag-o-matic toolchain-funcs

MY_PN=pyOpenSSL
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="
	https://www.pyopenssl.org/
	https://pypi.org/project/pyOpenSSL/
	https://github.com/pyca/pyopenssl/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.2[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		virtual/python-cffi[${PYTHON_USEDEP}]
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.1[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx doc \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

src_configure() {
	# test for 32-bit time_t
	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} -c -x c - -o /dev/null <<-EOF &>/dev/null
		#include <sys/types.h>
		int test[sizeof(time_t) >= 8 ? 1 : -1];
	EOF
	if [[ ${?} -eq 0 ]]; then
		PYOPENSSL_SKIP_LARGE_TIME=
		einfo "time_t is at least 64-bit long"
	else
		PYOPENSSL_SKIP_LARGE_TIME=1
		einfo "time_t is smaller than 64 bits, will skip broken tests"
	fi
}

python_test() {
	local -x TZ=UTC
	local deselect=(
		tests/test_ssl.py::TestContext::test_set_default_verify_paths
	)
	[[ ${PYOPENSSL_SKIP_LARGE_TIME} ]] && deselect+=(
		tests/test_crypto.py::TestX509StoreContext::test_verify_with_time
	)
	epytest ${deselect[@]/#/--deselect }
}
