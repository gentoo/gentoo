# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
# PYTHON_COMPAT is used only for testing
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit distutils-r1 pypi

FLIT_CORE_PV=3.12.0

MY_P=${P#ensurepip-}
DESCRIPTION="Shared pip wheel for ensurepip Python module"
HOMEPAGE="
	https://pip.pypa.io/en/stable/
	https://pypi.org/project/pip/
	https://github.com/pypa/pip/
"
SRC_URI="
	https://github.com/pypa/pip/archive/${PV}.tar.gz -> ${MY_P}.gh.tar.gz
	test? (
		$(pypi_wheel_url flit-core "${FLIT_CORE_PV}")
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test test-rust"
RESTRICT="!test? ( test )"

BDEPEND="
	${RDEPEND}
	test? (
		<dev-python/ensurepip-setuptools-80
		dev-python/ensurepip-wheel
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/scripttest[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		test-rust? (
			dev-python/cryptography[${PYTHON_USEDEP}]
		)
		dev-vcs/git
	)
"

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

declare -A VENDOR_LICENSES=(
	[cachecontrol]=Apache-2.0
	[certifi]=MPL-2.0
	[dependency_groups]=MIT
	[distlib]=PSF-2
	[distro]=Apache-2.0
	[idna]=BSD
	[msgpack]=Apache-2.0
	[packaging]="|| ( Apache-2.0 MIT )"
	[pkg_resources]=MIT
	[platformdirs]=MIT
	[pygments]=BSD-2
	[pyproject_hooks]=MIT
	[requests]=Apache-2.0
	[resolvelib]=ISC
	[rich]=MIT
	[tomli]=MIT
	[tomli_w]=MIT
	[truststore]=MIT
	[urllib3]=MIT
)
LICENSE+=" ${VENDOR_LICENSES[*]}"

python_prepare_all() {
	local PATCHES=(
		# remove coverage & pytest-subket wheel expectation from test suite
		# (from dev-python/pip)
		"${FILESDIR}/pip-26.0-test-wheels.patch"
	)

	distutils-r1_python_prepare_all

	if use test; then
		local wheels=(
			"${BROOT}"/usr/lib/python/ensurepip/{setuptools,wheel}-*.whl
			"${DISTDIR}/$(pypi_wheel_name flit-core "${FLIT_CORE_PV}")"
		)
		mkdir tests/data/common_wheels/ || die
		cp "${wheels[@]}" tests/data/common_wheels/ || die
	fi

	# Verify that we've covered licenses for all vendored packages
	cd src/pip/_vendor || die
	local packages=( */ )
	local pkg missing=()
	for pkg in "${packages[@]%/}"; do
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

	local upstream_count=$(wc -l < vendor.txt || die)
	if [[ ${#packages[@]} -ne ${upstream_count} ]]; then
		eerror "VENDOR_LICENSES: ${#packages[@]}"
		eerror "vendor.txt:      ${upstream_count}"
		die "Not all vendored packages matched"
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		tests/functional/test_inspect.py::test_inspect_basic
		# Internet
		tests/functional/test_config_settings.py::test_backend_sees_config_via_sdist
		tests/functional/test_install.py::test_double_install_fail
		tests/functional/test_install.py::test_install_sdist_links
		tests/functional/test_install_config.py::test_prompt_for_keyring_if_needed
		tests/functional/test_lock.py::test_lock_archive
		tests/functional/test_lock.py::test_lock_vcs
		# broken by system site-packages use
		tests/functional/test_freeze.py::test_freeze_with_setuptools
		tests/functional/test_pip_runner_script.py::test_runner_work_in_environments_with_no_pip
		tests/functional/test_uninstall.py::test_basic_uninstall_distutils
		tests/unit/test_base_command.py::test_base_command_global_tempdir_cleanup
		tests/unit/test_base_command.py::test_base_command_local_tempdir_cleanup
		tests/unit/test_base_command.py::test_base_command_provides_tempdir_helpers
	)
	local EPYTEST_IGNORE=(
		# from upstream options
		src/pip/_vendor
		tests/tests_cache
		# requires proxy.py
		tests/functional/test_proxy.py
	)

	case ${EPYTHON} in
		pypy3*)
			EPYTEST_DESELECT+=(
				# unexpected tempfiles?
				tests/functional/test_install_config.py::test_do_not_prompt_for_authentication
				tests/functional/test_install_config.py::test_prompt_for_authentication
				# wrong path
				tests/functional/test_install.py::test_install_editable_with_prefix_setup_py
				# wrong exception assumptions
				tests/unit/test_utils_datetime.py::test_parse_iso_datetime_invalid
			)
			;;
	esac

	if ! has_version "dev-python/cryptography[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/functional/test_install.py::test_install_sends_client_cert
			tests/functional/test_install_config.py::test_do_not_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_keyring_if_needed
		)
	fi

	local -x PIP_DISABLE_PIP_VERSION_CHECK=1
	# rerunfailures because test suite breaks if packages are installed
	# in parallel
	epytest -m "not network" -o addopts= -o tmp_path_retention_policy=all \
		--use-venv
}

src_install() {
	if [[ ${DISTUTILS_WHEEL_PATH} != *py3-none-any.whl ]]; then
		die "Non-pure wheel produced?! ${DISTUTILS_WHEEL_PATH}"
	fi
	# TODO: compress it?
	insinto /usr/lib/python/ensurepip
	doins "${DISTUTILS_WHEEL_PATH}"
}
