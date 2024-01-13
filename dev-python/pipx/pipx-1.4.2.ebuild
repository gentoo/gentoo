# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

TEST_SHIM=pipx-1.4.1-test-shim
DESCRIPTION="Install and Run Python Applications in Isolated Environments"
HOMEPAGE="
	https://pipx.pypa.io/stable/
	https://pypi.org/project/pipx/
	https://github.com/pypa/pipx/
"
# no tests in sdist
SRC_URI="
	https://github.com/pypa/pipx/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://dev.gentoo.org/~mgorny/dist/${TEST_SHIM}.tar.xz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/argcomplete-1.9.4[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.10)
	>=dev-python/userpath-1.9.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/ensurepip-pip
		dev-python/ensurepip-setuptools
		dev-python/ensurepip-wheel
		dev-python/pypiserver[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	if use test; then
		cp -vs "${BROOT}"/usr/lib/python/ensurepip/{pip,setuptools,wheel}-*.whl \
			"${WORKDIR}/${TEST_SHIM}/" || die
		mkdir -p .pipx_tests/package_cache || die
		local v
		for v in 3.{10..12}; do
			ln -s "${WORKDIR}/${TEST_SHIM}" \
				".pipx_tests/package_cache/${v}" || die
		done

		: > scripts/update_package_cache.py || die
		# sigh
		sed -e 's:server = str.*:server = "pypi-server":' \
			-i tests/conftest.py || die
	fi

	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/test_run.py::test_run_ensure_null_pythonpath
		tests/test_run.py::test_run_script_from_internet
		'tests/test_install.py::test_install_package_specs[pycowsay-git+https://github.com/cs01/pycowsay.git@master]'
		tests/test_install.py::test_force_install_changes
		'tests/test_install.py::test_install_package_specs[nox-https://github.com/wntrblm/nox/archive/2022.1.7.zip]'
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -x
}
