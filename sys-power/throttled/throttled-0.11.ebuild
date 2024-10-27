# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit linux-info python-single-r1 systemd

DESCRIPTION="Daemon to work around throttling issues on some Intel laptops"
HOMEPAGE="https://github.com/erpalma/throttled"
SRC_URI="https://github.com/erpalma/throttled/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"

CONFIG_CHECK="~X86_MSR ~DEVMEM"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
	')
	sys-apps/pciutils
"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_install() {
	default
	python_newscript throttled.py throttled
	python_domodule mmio.py
	newinitd "${FILESDIR}/throttled.initd" throttled
	systemd_dounit "${FILESDIR}/throttled.service"
	insinto /etc
	doins etc/throttled.conf
}
