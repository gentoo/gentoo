# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="https://tox.readthedocs.io https://github.com/tox-dev/tox https://pypi.org/project/tox/"
SRC_URI="https://github.com/tox-dev/tox/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
# doc disabled because of missing deps in tree
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.12[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	>=dev-python/six-1.14[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-16.0.0[${PYTHON_USEDEP}]"
# TODO: figure out how to make tests work without the package being
# installed first.
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/flaky-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/freezegun-0.3.11[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.0.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)"

src_configure() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	local EPYTEST_DESELECT=(
		# broken without Internet
		tests/unit/session/test_provision.py::test_provision_non_canonical_dep
		tests/integration/test_provision_int.py::test_provision_interrupt_child

		# expects python2 to exist
		tests/unit/interpreters/test_interpreters.py::test_tox_get_python_executable

		# fragile and relies on checking stdout
		tests/unit/util/test_spinner.py::test_spinner_progress
	)

	[[ ${EPYTHON} != pypy3 ]] && EPYTEST_DESELECT+=(
		# TODO?
		tests/unit/interpreters/test_interpreters.py::test_find_alias_on_path

		# broken without tox installed first
		# TODO: why it can't import itself?
		tests/integration/test_parallel_interrupt.py::test_parallel_interrupt
	)

	distutils_install_for_testing --via-venv
	epytest --no-network
}
