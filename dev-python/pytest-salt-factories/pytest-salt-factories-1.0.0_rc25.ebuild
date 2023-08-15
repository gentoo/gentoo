# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_1{0..1} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="The new generation of the pytest-salt Plugin"
HOMEPAGE="https://github.com/saltstack/pytest-salt-factories"
SRC_URI="https://github.com/saltstack/${PN}/archive/${PV//_/}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/${PN}-${PV//_/}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="test"

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
	${RDEPEND}
	test? (
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
		dev-python/pyfakefs[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

PATCHES=(
)

distutils_enable_tests pytest

python_prepare_all() {
	sed -r -e "s:use_scm_version=True:version='${PV}', name='${PN//-/.}':" -i setup.py || die
	sed -r -e '/(setuptools|setup_requires)/ d' -i setup.cfg || die

	sed -i 's:tool.setuptools_scm:tool.disabled:' pyproject.toml || die
	printf '__version__ = "%s"\n' "${PV}" > src/saltfactories/version.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local -a EPYTEST_DESELECT=(
		tests/functional/factories/cli/test_call.py::test_version_info
		tests/functional/factories/cli/test_cloud.py::test_version_info
		tests/functional/factories/cli/test_cp.py::test_version_info
		tests/functional/factories/cli/test_key.py::test_version_info
		tests/functional/factories/cli/test_run.py::test_version_info
		tests/functional/factories/cli/test_salt.py::test_version_info
		tests/functional/factories/cli/test_spm.py::test_version_info
		tests/functional/factories/cli/test_ssh.py::test_version_info
		tests/integration/factories/daemons/ssh/test_salt_ssh.py::test_salt_ssh
		tests/integration/factories/daemons/sshd/test_sshd.py::test_connect
		tests/scenarios/examples/test_echoext.py::test_echoext
		tests/functional/factories/daemons/test_container_factory.py::test_skip_on_pull_failure
		tests/functional/factories/daemons/test_container_factory.py::test_skip_if_docker_client_not_connectable
	)

	local tempdir
	# ${T} is too long a path for the tests to work
	tempdir="$(mktemp -du --tmpdir=/tmp salt-XXX)" || die
	addwrite "${tempdir}"

	(
		cleanup() { rm -rf "${tempdir}" || die; }

		trap cleanup EXIT
		export SHELL="/bin/bash" TMPDIR="${tempdir}"
		epytest --no-sys-stats
	)
}
