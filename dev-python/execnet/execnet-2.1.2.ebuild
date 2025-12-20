# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/pytest-dev/execnet
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Rapid multi-Python deployment"
HOMEPAGE="
	https://codespeak.net/execnet/
	https://github.com/pytest-dev/execnet/
	https://pypi.org/project/execnet/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		python3.1[34]t)
			EPYTEST_DESELECT+=(
				# https://github.com/pytest-dev/execnet/issues/306
				testing/test_channel.py::TestChannelBasicBehaviour::test_channel_callback_remote_freed
			)
			;;
	esac

	# the test suite checks if bytecode writing can be disabled/enabled
	local -x PYTHONDONTWRITEBYTECODE=
	# some tests are implicitly run against both sys.executable
	# and pypy3, which is redundant and results in pypy3 bytecode being
	# written to cpython install dirs
	epytest testing -k "not pypy3"
}
