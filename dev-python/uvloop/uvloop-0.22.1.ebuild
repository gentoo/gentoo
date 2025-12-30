# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Ultra-fast implementation of asyncio event loop on top of libuv"
HOMEPAGE="
	https://github.com/magicstack/uvloop/
	https://pypi.org/project/uvloop/
"
SRC_URI+="
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-0.19.0-cython3.patch.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 -riscv ~sparc x86"
IUSE="examples"

DEPEND="
	>=dev-libs/libuv-1.11.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-python/cython-3.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pyopenssl-22.0.0[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( aiohttp )
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	rm -r vendor || die
	cat <<-EOF >> setup.cfg || die
		[build_ext]
		use_system_libuv=True
		cython_always=True
	EOF

	# force cythonization
	rm uvloop/loop.c || die

	# don't append -O2...  however, it's not splitting args correctly,
	# so let's pass something safe
	export UVLOOP_OPT_CFLAGS=-Wall

	# https://github.com/MagicStack/uvloop/issues/701
	sed -i -e 's:3, 14:3, 13:' tests/test_tcp.py || die
}

python_test() {
	local EPYTEST_IGNORE=(
		# linting
		tests/test_sourcecode.py
	)
	local EPYTEST_DESELECT=(
		# unhappy about sandbox injecting its envvars
		tests/test_process.py::Test_UV_Process::test_process_env_2
		tests/test_process.py::Test_AIO_Process::test_process_env_2
		# crashes on assertion
		# https://github.com/MagicStack/uvloop/issues/574
		tests/test_cython.py::TestCythonIntegration::test_cython_coro_is_coroutine
		# Internet
		tests/test_dns.py::Test_UV_DNS::test_getaddrinfo_{8,9}
	)

	rm -rf uvloop || die
	epytest -s
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
