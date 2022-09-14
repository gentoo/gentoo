# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 udev

DESCRIPTION="An open source ecosystem for IoT development"
HOMEPAGE="https://platformio.org/"
SRC_URI="https://github.com/platformio/platformio-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-core-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		<dev-python/aiofiles-0.9[${PYTHON_USEDEP}]
		dev-python/ajsonrpc[${PYTHON_USEDEP}]
		<dev-python/bottle-0.13[${PYTHON_USEDEP}]
		>=dev-python/click-8[${PYTHON_USEDEP}]
		<dev-python/click-9[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		>=dev-python/pyserial-3[${PYTHON_USEDEP}]
		<dev-python/pyserial-4[${PYTHON_USEDEP}]
		>=dev-python/requests-2.4[${PYTHON_USEDEP}]
		<dev-python/requests-3[${PYTHON_USEDEP}]
		>=dev-python/semantic_version-2.9[${PYTHON_USEDEP}]
		<dev-python/semantic_version-3[${PYTHON_USEDEP}]
		>=dev-python/tabulate-0.8.3[${PYTHON_USEDEP}]
		<dev-python/tabulate-1[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
		>=dev-python/pyelftools-0.25[${PYTHON_USEDEP}]
		<dev-python/pyelftools-1[${PYTHON_USEDEP}]
		>=dev-python/marshmallow-2.20.5[${PYTHON_USEDEP}]
		=dev-python/starlette-0.18*[${PYTHON_USEDEP}]
		=dev-python/uvicorn-0.17*[${PYTHON_USEDEP}]
		dev-python/wsproto[${PYTHON_USEDEP}]
		>=dev-python/zeroconf-0.37[${PYTHON_USEDEP}]
	')
	virtual/udev"
DEPEND="virtual/udev"
BDEPEND="test? ( $(python_gen_cond_dep 'dev-python/jsondiff[${PYTHON_USEDEP}]') )"

# This list could be refined a bit to have individual tests which need network
# (within EPYTEST_DESELECT) but so many need it that it doesn't seem worth it right now.
EPYTEST_IGNORE=(
	# Requires network access
	tests/test_builder.py
	tests/package/test_manager.py
	tests/package/test_manifest.py
	tests/commands/test_platform.py
	tests/commands/test_test.py
	tests/commands/test_ci.py
	tests/commands/test_init.py
	tests/commands/test_lib.py
	tests/commands/test_lib_complex.py
	tests/commands/test_boards.py
	tests/commands/test_check.py
	tests/commands/test_run.py
	tests/commands/pkg/test_exec.py
	tests/commands/pkg/test_list.py
	tests/commands/pkg/test_outdated.py
	tests/commands/pkg/test_search.py
	tests/commands/pkg/test_show.py
	tests/commands/pkg/test_install.py
	tests/commands/pkg/test_uninstall.py
	tests/commands/pkg/test_update.py
	tests/misc/ino2cpp/test_ino2cpp.py
	tests/test_maintenance.py
	tests/test_misc.py
)

EPYTEST_DESELECT=(
	# Requires network access
	tests/misc/test_maintenance.py::test_check_pio_upgrade
	tests/misc/test_misc.py::test_ping_internet_ips
	tests/misc/test_misc.py::test_api_cache
)

distutils_enable_tests pytest

src_prepare() {
	# Allow newer versions of zeroconf, Bug #831181.
	# Also wsproto.
	# ... and semantic_version, bug #853247.
	sed \
		-e '/zeroconf/s/<[0-9.*]*//' \
		-e '/wsproto/s/==.*/"/' \
		-e '/semantic_version/s/==[0-9.*]*//' \
		-i setup.py || die

	default
}

python_test() {
	epytest -k "not skip_ci"
}

src_install() {
	distutils-r1_src_install
	udev_dorules scripts/99-platformio-udev.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
