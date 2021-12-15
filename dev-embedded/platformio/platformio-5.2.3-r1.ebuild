# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="An open source ecosystem for IoT development"
HOMEPAGE="https://platformio.org/"
SRC_URI="https://github.com/platformio/platformio-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-core-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	$(python_gen_cond_dep '
		=dev-python/aiofiles-0.7.0*[${PYTHON_USEDEP}]
		<dev-python/bottle-0.13[${PYTHON_USEDEP}]
		>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
		<dev-python/click-9[${PYTHON_USEDEP}]
		dev-python/colorama[${PYTHON_USEDEP}]
		>=dev-python/pyserial-3[${PYTHON_USEDEP}]
		<dev-python/pyserial-4[${PYTHON_USEDEP}]
		>=dev-python/requests-2.4[${PYTHON_USEDEP}]
		<dev-python/requests-3[${PYTHON_USEDEP}]
		>=dev-python/semantic_version-2.8.1[${PYTHON_USEDEP}]
		<dev-python/semantic_version-3[${PYTHON_USEDEP}]
		>=dev-python/tabulate-0.8.3[${PYTHON_USEDEP}]
		<dev-python/tabulate-1[${PYTHON_USEDEP}]
		dev-python/twisted[${PYTHON_USEDEP}]
		>=dev-python/pyelftools-0.25[${PYTHON_USEDEP}]
		<dev-python/pyelftools-1[${PYTHON_USEDEP}]
		>=dev-python/marshmallow-2.20.5[${PYTHON_USEDEP}]
		dev-python/starlette[${PYTHON_USEDEP}]
		=dev-python/uvicorn-0.15*[${PYTHON_USEDEP}]
		dev-python/wsproto[${PYTHON_USEDEP}]
		dev-python/zeroconf[${PYTHON_USEDEP}]
	')"
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
	tests/test_ino2cpp.py
	tests/test_maintenance.py
	tests/test_misc.py
)

distutils_enable_tests pytest
