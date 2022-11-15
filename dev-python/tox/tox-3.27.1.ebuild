# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="
	https://tox.readthedocs.io/
	https://github.com/tox-dev/tox/
	https://pypi.org/project/tox/
"
SRC_URI="
	https://github.com/tox-dev/tox/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.12[${PYTHON_USEDEP}]
	dev-python/py[${PYTHON_USEDEP}]
	>=dev-python/six-1.14[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-20.1.0[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.0.0[${PYTHON_USEDEP}]
	' 3.8 3.9 3.10)
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/flaky-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/freezegun-0.3.11[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_DESELECT=(
		# broken without Internet
		tests/unit/session/test_provision.py::test_provision_non_canonical_dep
		tests/integration/test_provision_int.py::test_provision_interrupt_child

		# expects python2 to exist
		tests/unit/interpreters/test_interpreters.py::test_tox_get_python_executable
	)

	[[ ${EPYTHON} != pypy3 ]] && EPYTEST_DESELECT+=(
		# capfd doesn't seem to work for some non-obvious reason
		tests/unit/test_z_cmdline.py::TestSession::test_summary_status
		tests/unit/session/test_provision.py::test_provision_bad_requires

		# TODO?
		tests/unit/interpreters/test_interpreters.py::test_find_alias_on_path
	)

	epytest --no-network
}
