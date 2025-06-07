# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=pyOpenSSL
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 toolchain-funcs pypi

DESCRIPTION="Python interface to the OpenSSL library"
HOMEPAGE="
	https://www.pyopenssl.org/
	https://github.com/pyca/pyopenssl/
	https://pypi.org/project/pyOpenSSL/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	<dev-python/cryptography-46[${PYTHON_USEDEP}]
	>=dev-python/cryptography-41.0.5[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.9[${PYTHON_USEDEP}]
	' 3.{11..12})
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

src_test() {
	local -x TZ=UTC
	local EPYTEST_DESELECT=(
		tests/test_ssl.py::TestContext::test_set_default_verify_paths
	)

	if ! tc-has-64bit-time_t; then
		einfo "time_t is smaller than 64 bits, will skip broken tests"
		EPYTEST_DESELECT+=(
			tests/test_crypto.py::TestX509StoreContext::test_verify_with_time
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	distutils-r1_src_test
}

python_test() {
	epytest -p rerunfailures
}
