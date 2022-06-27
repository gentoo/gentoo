# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1 optfeature

DESCRIPTION="Python API and shell utilities to monitor file system events"
HOMEPAGE="
	https://github.com/gorakhargosh/watchdog/
	https://pypi.org/project/watchdog/
"
SRC_URI="
	https://github.com/gorakhargosh/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pytest-timeout-0.3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	default
}

python_test() {
	local EPYTEST_DESELECT=(
		# requires root powers via sudo (yes, seriously)
		tests/test_inotify_buffer.py::test_unmount_watched_directory_filesystem
	)

	epytest -p no:django
}

pkg_postinst() {
	optfeature "Bash completion" dev-python/argcomplete
}
