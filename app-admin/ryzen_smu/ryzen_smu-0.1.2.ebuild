# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod linux-info toolchain-funcs

SRC_URI="https://github.com/leogx9r/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Kernel driver for AMD Ryzen's System Management Unit"
HOMEPAGE="https://github.com/leogx9r/ryzen_smu"

SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=""
RDEPEND=""

MODULE_NAMES="ryzen_smu(misc)"

pkg_setup() {
	linux_config_exists

	linux-mod_pkg_setup

	BUILD_TARGETS="modules"
	BUILD_PARAMS="CC=$(tc-getBUILD_CC) KERNEL_BUILD=${KERNEL_DIR}"
}

src_install() {
	linux-mod_src_install
	insinto /usr/lib/modules-load.d/
	newins "${FILESDIR}"/ryzen_smu.conf ryzen_smu.conf

}
