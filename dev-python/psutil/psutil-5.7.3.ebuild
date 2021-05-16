# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Retrieve information on running processes and system utilization"
HOMEPAGE="https://github.com/giampaolo/psutil https://pypi.org/project/psutil/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/psutil-5.7.2-tests.patch"
)

python_test() {
	if [[ ${EPYTHON} == pypy* ]]; then
		ewarn "Not running tests on ${EPYTHON} since they are broken"
		return 0
	fi

	# since we are running in an environment a bit similar to CI,
	# let's skip the tests that are disable for CI
	TRAVIS=1 APPVEYOR=1 "${EPYTHON}" psutil/tests/runner.py ||
		die "tests failed with ${EPYTHON}"
}

python_compile() {
	# force -j1 to avoid .o linking race conditions
	local MAKEOPTS=-j1
	distutils-r1_python_compile
}
