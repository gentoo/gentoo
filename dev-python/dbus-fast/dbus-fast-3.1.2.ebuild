# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
# TODO: freethreading compatible
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 virtualx

DESCRIPTION="A faster version of dbus-next"
HOMEPAGE="
	https://github.com/bluetooth-devices/dbus-fast/
	https://pypi.org/project/dbus-fast/
"
SRC_URI="
	https://github.com/Bluetooth-Devices/dbus-fast/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv"

BDEPEND="
	>=dev-python/cython-3[${PYTHON_USEDEP}]
	>=dev-python/setuptools-65.4.1[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pycairo-1.21.0[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3.50[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,timeout} )
distutils_enable_tests pytest

export REQUIRE_CYTHON=1

src_test() {
	local dbus_params=(
		$(dbus-daemon --session --print-address --fork --print-pid)
	)
	local -x DBUS_SESSION_BUS_ADDRESS=${dbus_params[0]}

	virtx distutils-r1_src_test

	kill "${dbus_params[1]}" || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# interface not found on this object: org.freedesktop.DBus.Debug.Stats
		tests/client/test_signals.py::test_signals
	)
	local EPYTEST_IGNORE=(
		tests/benchmarks
	)

	nonfatal epytest -o addopts= || die
}
