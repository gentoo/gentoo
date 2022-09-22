# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Ultra-fast implementation of asyncio event loop on top of libuv"
HOMEPAGE="
	https://github.com/magicstack/uvloop/
	https://pypi.org/project/uvloop/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 -riscv ~sparc ~x86"
LICENSE="MIT"
SLOT="0"
IUSE="examples"

DEPEND="
	>=dev-libs/libuv-1.11.0:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-python/cython-0.29.32[${PYTHON_USEDEP}]
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-22.0.0[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	rm -r vendor || die
	cat <<-EOF >> setup.cfg || die
		[build_ext]
		use_system_libuv=True
		cython_always=True
	EOF

	# flake8 only
	#rm tests/test_sourcecode.py || die
	# force cythonization
	rm uvloop/loop.c || die
	# hangs
	#sed -i -e 's:test_remote_shutdown_receives_trailing_data:_&:' \
	#	tests/test_tcp.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_IGNORE=(
		# linting
		tests/test_sourcecode.py
	)
	local EPYTEST_DESELECT=(
		# TODO: expects some... cython_helper?
		tests/test_libuv_api.py::Test_UV_libuv::test_libuv_get_loop_t_ptr
		# unhappy about sandbox injecting its envvars
		tests/test_process.py::Test_UV_Process::test_process_env_2
		tests/test_process.py::Test_AIO_Process::test_process_env_2
		# hangs
		tests/test_tcp.py::Test_AIO_TCPSSL::test_remote_shutdown_receives_trailing_data
	)

	rm -rf uvloop || die
	epytest -s
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
