# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="CRC32c algorithm in hardware and software"
HOMEPAGE="
	https://github.com/ICRAR/crc32c/
	https://pypi.org/project/crc32c/
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~sparc ~x86"
# NB: these don't affect the build, they are only used for tests
IUSE="cpu_flags_arm_crc32 cpu_flags_x86_sse4_2"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/ICRAR/crc32c/pull/44
	"${FILESDIR}/${P}-sparc.patch"
)

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x CRC32C_SW_MODE

	# force = run "software" code (i.e. unoptimized)
	# none = run "hardware" code (i.e. SSE4.2 / ARMv8 CRC32)
	for CRC32C_SW_MODE in none force; do
		if [[ ${CRC32C_SW_MODE} == none ]]; then
			if ! use cpu_flags_arm_crc32 && ! use cpu_flags_x86_sse4_2; then
				continue
			fi

			# the test suite just skips all tests, so double-check
			"${EPYTHON}" -c "import crc32c" ||
				die "Importing crc32c failed (accelerated code path broken?)"
		fi

		einfo "Testing with CRC32C_SW_MODE=${CRC32C_SW_MODE}"
		epytest
	done
}
