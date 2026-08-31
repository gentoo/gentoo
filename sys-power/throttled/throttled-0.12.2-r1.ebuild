# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 linux-info systemd

DESCRIPTION="Daemon to work around throttling issues on some Intel laptops"
HOMEPAGE="https://github.com/erpalma/throttled"
SRC_URI="https://github.com/erpalma/throttled/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="~X86_MSR ~DEVMEM"

# sys-power/upower: dependency via dbus
RDEPEND="
	dev-python/dbus-fast[${PYTHON_USEDEP}]
	sys-apps/pciutils
	sys-power/upower
"

src_install() {
	distutils-r1_src_install
	newinitd "${FILESDIR}/throttled.initd" throttled
	systemd_dounit "${FILESDIR}/throttled.service"
	insinto /etc
	doins etc/throttled.conf
}

EPYTEST_IGNORE=(
	# not relevant downstream
	tests/test_build_deb.py
	tests/test_packaging.py
)
EPYTEST_PLUGINS=()
distutils_enable_tests pytest
