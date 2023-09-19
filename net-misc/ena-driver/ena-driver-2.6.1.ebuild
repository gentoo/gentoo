# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info linux-mod

DESCRIPTION="Amazon EC2 Elastic Network Adapter (ENA) kernel driver"
HOMEPAGE="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking-ena.html"
SRC_URI="https://github.com/amzn/amzn-drivers/archive/ena_linux_${PV}.tar.gz -> ${P}-linux.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/amzn-drivers-ena_linux_${PV}/kernel/linux/ena"

MODULE_NAMES="ena(net:${S}:${S})"
BUILD_TARGETS="all"

CONFIG_CHECK="PCI_MSI !CPU_BIG_ENDIAN DIMLIB"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="CONFIG_MODULE_SIG=n KERNEL_DIR=${KV_DIR}"
}

src_prepare() {
	default

	sed -i -e 's!/lib/modules/\$(BUILD_KERNEL)/build!$(KERNEL_DIR)!g' \
		"Makefile" || die "Unable to fix Makefile"
}

src_install() {
	linux-mod_src_install
	dodoc README RELEASENOTES.md
}
