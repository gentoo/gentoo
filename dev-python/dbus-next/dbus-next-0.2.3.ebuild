# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 virtualx

DESCRIPTION="The next great DBus library for Python with asyncio support"
HOMEPAGE="https://python-dbus-next.readthedocs.io/en/latest/"
SRC_URI="https://github.com/altdesktop/python-dbus-next/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/python-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="test? (
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)"

EPYTEST_IGNORE=(
	# "interface not found on this object: org.freedesktop.DBus.Debug.Stats"
	# Seems like we build dbus w/o this?
	test/client/test_signals.py
)

distutils_enable_tests pytest

src_test() {
	local dbus_params=(
		$(dbus-daemon --session --print-address --fork --print-pid)
	)
	local -x DBUS_SESSION_BUS_ADDRESS=${dbus_params[0]}

	virtx distutils-r1_src_test

	kill "${dbus_params[1]}" || die
}
