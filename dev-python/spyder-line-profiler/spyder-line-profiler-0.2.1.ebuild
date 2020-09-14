# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 virtualx

DESCRIPTION="Plugin to run the python line profiler from within the spyder editor"
HOMEPAGE="https://github.com/spyder-ide/spyder-line-profiler"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/line_profiler[${PYTHON_USEDEP}]
	>=dev-python/spyder-4.0.0[${PYTHON_USEDEP}]
	<dev-python/spyder-5.0.0[${PYTHON_USEDEP}]
"

DEPEND="test? (
	dev-python/pytest-qt[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

python_test() {
	virtx pytest -vv spyder_line_profiler/widgets/tests
}
