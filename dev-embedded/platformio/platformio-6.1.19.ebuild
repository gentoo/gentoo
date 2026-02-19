# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 shell-completion udev

DESCRIPTION="An open source ecosystem for IoT development"
HOMEPAGE="https://platformio.org/"
SRC_URI="https://github.com/platformio/platformio-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-core-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#TODO dev-python/requests[socks5] if proxy needed

RDEPEND="
	$(python_gen_cond_dep '
		=dev-python/ajsonrpc-1.2*[${PYTHON_USEDEP}]
		=dev-python/bottle-0.13*[${PYTHON_USEDEP}]
		>=dev-python/click-8.2[${PYTHON_USEDEP}]
		<dev-python/click-8.4[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		=dev-python/pyserial-3.5*[${PYTHON_USEDEP}]
		>=dev-python/zeroconf-0.37[${PYTHON_USEDEP}]
		=dev-python/requests-2*[${PYTHON_USEDEP}]
		=dev-python/semantic-version-2.10*[${PYTHON_USEDEP}]
		=dev-python/tabulate-0*[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
		dev-python/constantly[${PYTHON_USEDEP}]
		>=dev-python/pyelftools-0.30[${PYTHON_USEDEP}]
		<dev-python/pyelftools-1[${PYTHON_USEDEP}]
		=dev-python/marshmallow-4*[${PYTHON_USEDEP}]
		>=dev-python/starlette-0.21[${PYTHON_USEDEP}]
		<dev-python/starlette-0.60[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.19[${PYTHON_USEDEP}]
		<dev-python/uvicorn-0.50[${PYTHON_USEDEP}]
		=dev-python/wsproto-1*[${PYTHON_USEDEP}]
	')
	virtual/udev"
DEPEND="virtual/udev"
BDEPEND="test? ( $(python_gen_cond_dep 'dev-python/jsondiff[${PYTHON_USEDEP}]') )"

# This list has been refined to have the individual tests which need network access
# to be disabled (or those that need a test email account).
#  this list will need careful monitoring during version bumps
EPYTEST_IGNORE=(
	# Requires network access
	tests/commands/pkg/test_install.py
	tests/commands/pkg/test_list.py
	tests/commands/pkg/test_outdated.py
	tests/commands/pkg/test_search.py
	tests/commands/pkg/test_show.py
	tests/commands/pkg/test_uninstall.py
	tests/commands/pkg/test_update.py
	tests/commands/test_account_org_team.py
	tests/commands/test_boards.py
	tests/commands/test_check.py
	tests/commands/test_lib.py
	tests/commands/test_lib_complex.py
	tests/commands/test_platform.py
	tests/commands/test_run.py
	tests/commands/test_test.py
	tests/misc/ino2cpp/test_ino2cpp.py
	tests/misc/test_maintenance.py
	tests/project/test_metadata.py
	tests/test_examples.py
)

EPYTEST_DESELECT=(
	# Requires network access
	tests/commands/pkg/test_exec.py::test_pkg_specified
	tests/commands/pkg/test_exec.py::test_unrecognized_options
	tests/commands/test_ci.py::test_ci_boards
	tests/commands/test_ci.py::test_ci_build_dir
	tests/commands/test_ci.py::test_ci_keep_build_dir
	tests/commands/test_ci.py::test_ci_keep_build_dir_nested_src_dirs
	tests/commands/test_ci.py::test_ci_keep_build_dir_single_src_dir
	tests/commands/test_ci.py::test_ci_lib_and_board
	tests/commands/test_ci.py::test_ci_project_conf
	tests/commands/test_init.py::test_init_custom_framework
	tests/commands/test_init.py::test_init_duplicated_boards
	tests/commands/test_init.py::test_init_enable_auto_uploading
	tests/commands/test_init.py::test_init_ide_eclipse
	tests/commands/test_init.py::test_init_ide_vscode
	tests/commands/test_init.py::test_init_incorrect_board
	tests/commands/test_init.py::test_init_special_board
	tests/misc/test_misc.py::test_api_cache
	tests/misc/test_misc.py::test_ping_internet_ips
	tests/package/test_manager.py::test_download
	tests/package/test_manager.py::test_install_force
	tests/package/test_manager.py::test_install_from_registry
	tests/package/test_manager.py::test_install_lib_depndencies
	tests/package/test_manager.py::test_registry
	tests/package/test_manager.py::test_uninstall
	tests/package/test_manager.py::test_update_with_metadata
	tests/package/test_manager.py::test_update_without_metadata
	tests/package/test_manifest.py::test_library_json_schema
	tests/package/test_manifest.py::test_platform_json_schema
	tests/project/test_config.py::test_win_core_root_dir
)

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/pio-6.1.19-marshmallow-4.patch
)

python_prepare_all() {
	# Allow marshmallow-4*
	# Allow starlette-0.5*
	# Allow uvicorn-0.4*
	sed \
		-e '/marshmallow/s/3\.[0-9.*]*/4.*/' \
		-e '/starlette/s/<0\.5[0-9]*/<0.60/' \
		-e '/uvicorn/s/<0\.4[0-9]*/<0.50/' \
		-i platformio/dependencies.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	epytest -k "not skip_ci"
}

python_compile_all() {
	#completions
	local _PIO_COMPLETE s_type
	for s_type in bash fish zsh; do
		_PIO_COMPLETE=${s_type}_source "${BUILD_DIR}"/install/usr/bin/pio > "${T}"/pio.${s_type} || die
	done
}

src_install() {
	distutils-r1_src_install
	udev_dorules platformio/assets/system/99-platformio-udev.rules

	newbashcomp "${T}"/pio.bash pio
	newfishcomp "${T}"/pio.fish pio.fish
	newzshcomp "${T}"/pio.zsh _pio
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
