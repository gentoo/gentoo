# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 toolchain-funcs

MY_PN=pyOpenSSL
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="
	https://www.pyopenssl.org/
	https://github.com/pyca/pyopenssl/
	https://pypi.org/project/pyOpenSSL/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	<dev-python/cryptography-39[${PYTHON_USEDEP}]
	>=dev-python/cryptography-38.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

src_test() {
	local -x TZ=UTC
	local EPYTEST_DESELECT=(
		tests/test_ssl.py::TestContext::test_set_default_verify_paths
	)

	# test for 32-bit time_t
	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} -c -x c - -o /dev/null <<-EOF &>/dev/null
		#include <sys/types.h>
		int test[sizeof(time_t) >= 8 ? 1 : -1];
	EOF

	if [[ ${?} -eq 0 ]]; then
		einfo "time_t is at least 64-bit long"
	else
		einfo "time_t is smaller than 64 bits, will skip broken tests"
		EPYTEST_DESELECT+=(
			tests/test_crypto.py::TestX509StoreContext::test_verify_with_time
		)
	fi

	distutils-r1_src_test
}
