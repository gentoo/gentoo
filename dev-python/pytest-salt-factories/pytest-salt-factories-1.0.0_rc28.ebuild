# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="The new generation of the pytest-salt Plugin"
HOMEPAGE="
	https://github.com/saltstack/pytest-salt-factories/
	https://pypi.org/project/pytest-salt-factories/
"
SRC_URI="
	https://github.com/saltstack/pytest-salt-factories/archive/${PV//_/}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${P//_/}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/docker[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/pytest-7.0.0[${PYTHON_USEDEP}]
	dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
	dev-python/pytest-skip-markers[${PYTHON_USEDEP}]
	dev-python/pytest-system-statistics[${PYTHON_USEDEP}]
	>=dev-python/pytest-shell-utilities-1.4.0[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=app-admin/salt-3005.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
		dev-python/pyfakefs[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	sed -i -e 's:helpers_namespace:pytest_&.plugin:' tests/conftest.py || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		tests/integration/factories/daemons/ssh/test_salt_ssh.py::test_salt_ssh
		tests/integration/factories/daemons/sshd/test_sshd.py::test_connect
	)

	local ret tempdir x
	# ${T} is too long a path for the tests to work
	tempdir="$(mktemp -du --tmpdir=/tmp salt-XXX)" || die
	addwrite "${tempdir}"

	local -x SHELL="/bin/bash" TMPDIR="${tempdir}"
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=saltfactories.plugins
	PYTEST_PLUGINS+=,pytest_helpers_namespace.plugin
	PYTEST_PLUGINS+=,pytestsysstats.plugin
	PYTEST_PLUGINS+=,pytest_subtests
	for x in factories markers sysinfo event_listener log_server loader
	do
		PYTEST_PLUGINS+=,saltfactories.plugins.${x}
	done
 
	nonfatal epytest --no-sys-stats -x
	ret=${?}

	rm -rf "${tempdir}" || die
	[[ ${ret} -ne 0 ]] && die "Tests failed with ${EPYTHON}"
}
