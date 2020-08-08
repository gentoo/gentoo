# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod

DESCRIPTION="r8125 driver for Realtek RTL8125 / RTL8125B(S) NICs (2.5G Gigabit Ethernet)"
HOMEPAGE="https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
	https://github.com/ibmibmibm/r8125/"
SRC_URI="https://github.com/ibmibmibm/r8125/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MODULE_NAMES="r8125(net:${S}/src)"
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
}

src_install() {
	linux-mod_src_install
	einstalldocs
}
