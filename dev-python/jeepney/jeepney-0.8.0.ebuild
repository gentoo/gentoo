# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Low-level, pure Python DBus protocol wrapper"
HOMEPAGE="
	https://gitlab.com/takluyver/jeepney/
	https://pypi.org/project/jeepney/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="examples"

BDEPEND="
	test? (
		dev-python/async-timeout[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.7.1[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
		sys-apps/dbus
	)
"

distutils_enable_tests pytest

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

src_test() {
	local dbus_params=(
		$(dbus-daemon --session --print-address --fork --print-pid)
	)
	local -x DBUS_SESSION_BUS_ADDRESS=${dbus_params[0]}

	distutils-r1_src_test

	kill "${dbus_params[1]}" || die
}

python_test() {
	local EPYTEST_IGNORE=()
	if ! has_version "dev-python/pytest-trio[${PYTHON_USEDEP}]"; then
		EPYTEST_IGNORE+=( jeepney/io/tests/test_trio.py )
	fi
	epytest
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
