# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYPI_PN=${PN#ensurepip-}
# PYTHON_COMPAT used only for testing
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 pypi

DESCRIPTION="Shared setuptools wheel for ensurepip Python module"
HOMEPAGE="
	https://github.com/pypa/setuptools/
	https://pypi.org/project/setuptools/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	${RDEPEND}
	test? (
		>=dev-python/build-1.0.3[${PYTHON_USEDEP}]
		>=dev-python/ini2toml-0.14[${PYTHON_USEDEP}]
		>=dev-python/filelock-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/jaraco-envs-2.2[${PYTHON_USEDEP}]
		>=dev-python/jaraco-path-3.7.2[${PYTHON_USEDEP}]
		>=dev-python/jaraco-test-5.5[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		dev-python/pyproject-hooks[${PYTHON_USEDEP}]
		>=dev-python/tomli-w-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-20[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{home,subprocess,timeout} )
EPYTEST_XDIST=1
distutils_enable_tests pytest

declare -A VENDOR_LICENSES=(
	[autocommand]=LGPL-3
	[backports.tarfile]=MIT
	[importlib_metadata]=Apache-2.0
	[jaraco_context]=MIT
	[jaraco_functools]=MIT
	[jaraco.text]=MIT
	[more_itertools]=MIT
	[packaging]="|| ( Apache-2.0 MIT )"
	[platformdirs]=MIT
	[tomli]=MIT
	[wheel]=MIT
	[zipp]=MIT
)
LICENSE+=" ${VENDOR_LICENSES[*]}"

src_prepare() {
	distutils-r1_src_prepare

	# Verify that we've covered licenses for all vendored packages
	cd setuptools/_vendor || die
	local packages=( *.dist-info )
	local pkg missing=()
	for pkg in "${packages[@]%%-*}"; do
		if [[ ! -v "VENDOR_LICENSES[${pkg}]" ]]; then
			missing+=( "${pkg}" )
		else
			unset "VENDOR_LICENSES[${pkg}]"
		fi
	done

	if [[ ${missing[@]} || ${VENDOR_LICENSES[@]} ]]; then
		[[ ${missing[@]} ]] &&
			eerror "License missing for packages: ${missing[*]}"
		[[ ${VENDOR_LICENSES[@]} ]] &&
			eerror "Vendored packages removed: ${!VENDOR_LICENSES[*]}"
		die "VENDOR_LICENSES outdated"
	fi
}

python_compile() {
	# If we're testing, install for all implementations.
	# If we're not, just get one wheel built.
	if use test || [[ -z ${DISTUTILS_WHEEL_PATH} ]]; then
		distutils-r1_python_compile
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		setuptools/tests/config/test_setupcfg.py::TestConfigurationReader::test_basic
		setuptools/tests/config/test_setupcfg.py::TestConfigurationReader::test_ignore_errors
		# TODO, probably some random package
		setuptools/tests/config/test_setupcfg.py::TestOptions::test_cmdclass
		# relies on -Werror
		setuptools/_static.py::setuptools._static.Dict
		setuptools/_static.py::setuptools._static.List
		# Internet
		setuptools/tests/test_namespaces.py::TestNamespaces::test_mixed_site_and_non_site
		setuptools/tests/test_namespaces.py::TestNamespaces::test_namespace_package_installed_and_cwd
		setuptools/tests/test_namespaces.py::TestNamespaces::test_packages_in_the_same_namespace_installed_and_cwd
		setuptools/tests/test_namespaces.py::TestNamespaces::test_pkg_resources_import
		# broken by warnings from setuptools-scm
		setuptools/tests/config/test_apply_pyprojecttoml.py::TestPresetField::test_scripts_dont_require_dynamic_entry_points
	)

	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# fails and breaks other tests
				setuptools/tests/test_editable_install.py
			)
			;;
	esac

	local -x PRE_BUILT_SETUPTOOLS_WHEEL=${DISTUTILS_WHEEL_PATH}
	epytest -o tmp_path_retention_policy=all \
		-m "not uses_network" setuptools
}

src_install() {
	if [[ ${DISTUTILS_WHEEL_PATH} != *py3-none-any.whl ]]; then
		die "Non-pure wheel produced?! ${DISTUTILS_WHEEL_PATH}"
	fi
	# TODO: compress it?
	insinto /usr/lib/python/ensurepip
	doins "${DISTUTILS_WHEEL_PATH}"
}
