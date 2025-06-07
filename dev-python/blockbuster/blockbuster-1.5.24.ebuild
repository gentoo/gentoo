# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Utility to detect blocking calls in the async event loop"
HOMEPAGE="
	https://github.com/cbornet/blockbuster/
	https://pypi.org/project/blockbuster/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~riscv ~s390 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/forbiddenfruit-0.1.4[${PYTHON_USEDEP}]
	' 'python*')
"
BDEPEND="
	test? (
		dev-python/aiofiles[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/test_blockbuster.py::test_ssl_socket
	)

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# upstream doesn't care, however that doesn't stop
				# people from depending on it...
				# https://github.com/cbornet/blockbuster/issues/47
				tests/test_blockbuster.py::test_file_random
				tests/test_blockbuster.py::test_file_read_bytes
				tests/test_blockbuster.py::test_file_text
				tests/test_blockbuster.py::test_file_write_bytes
				tests/test_blockbuster.py::test_lock
				tests/test_blockbuster.py::test_os_scandir
				tests/test_blockbuster.py::test_scanned_modules
			)
			;;
	esac

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio
}
