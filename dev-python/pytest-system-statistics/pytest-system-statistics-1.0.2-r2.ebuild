# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Pytest Plugin Which Reports System Usage Statistics"
HOMEPAGE="
	https://pypi.org/project/pytest-system-statistics/
	https://github.com/saltstack/pytest-system-statistics
"
SRC_URI="https://github.com/saltstack/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/pytest-system-statistics-1.0.2-loader.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -e "s/use_scm_version=True/version='${PV}'/" -i setup.py || die
	sed -e "/setuptools_scm/ d" -i setup.cfg || die
	sed -e "s/tool.setuptools_scm/tool.disabled/" -i pyproject.toml || die

	printf '__version__ = "${PV}"\n' > src/pytestsysstats/version.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		tests/functional/test_syststats.py::test_proc_sys_stats
		tests/functional/test_syststats.py::test_proc_sys_stats_no_children
	)
	epytest
}
