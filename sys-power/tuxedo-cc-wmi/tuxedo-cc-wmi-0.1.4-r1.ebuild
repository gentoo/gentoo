# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod toolchain-funcs

DESCRIPTION="Kernel Module for Tuxedo WMI"
HOMEPAGE="https://github.com/tuxedocomputers/tuxedo-cc-wmi"
SRC_URI="https://github.com/tuxedocomputers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BUILD_TARGETS="all"
MODULE_NAMES="tuxedo_cc_wmi(tuxedo:${S}:src)"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="CC=$(tc-getBUILD_CC) KDIR=${KV_DIR} V=1 KBUILD_VERBOSE=1"
}
