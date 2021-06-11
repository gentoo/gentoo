# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )
inherit distutils-r1 optfeature

DESCRIPTION="Python API and shell utilities to monitor file system events"
HOMEPAGE="https://github.com/gorakhargosh/watchdog"
SRC_URI="https://github.com/gorakhargosh/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

CDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	dev-python/argh[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? (
		>=dev-python/pytest-timeout-0.3[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	default
}

python_test() {
	local deselect=()
	[[ ${EPYTHON} == pypy3 ]] && deselect+=(
		tests/test_inotify_buffer.py::test_move_internal_batch
	)

	epytest -p no:django ${deselect[@]/#/--deselect }
}

pkg_postinst() {
	optfeature "Bash completion" dev-python/argcomplete
}
