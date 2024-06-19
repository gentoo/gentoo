# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

TEST_PATCH=psutil-6.0.0-tests.patch
DESCRIPTION="Retrieve information on running processes and system utilization"
HOMEPAGE="
	https://github.com/giampaolo/psutil/
	https://pypi.org/project/psutil/
"
SRC_URI+="
	https://dev.gentoo.org/~mgorny/dist/${TEST_PATCH}.xz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${WORKDIR}/${TEST_PATCH}"
)

python_test() {
	# Since we are running in an environment a bit similar to CI,
	# let's skip the tests that are disabled for CI
	local -x TRAVIS=1
	local -x APPVEYOR=1
	local -x GITHUB_ACTIONS=1
	local -x GENTOO_TESTING=1
	"${EPYTHON}" psutil/tests/runner.py ||
		die "tests failed with ${EPYTHON}"
}

python_compile() {
	# Force -j1 to avoid .o linking race conditions
	local MAKEOPTS=-j1
	distutils-r1_python_compile
}
