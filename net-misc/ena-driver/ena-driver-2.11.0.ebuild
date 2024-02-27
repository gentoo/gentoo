# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Amazon EC2 Elastic Network Adapter (ENA) kernel driver"
HOMEPAGE="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking-ena.html"
SRC_URI="https://github.com/amzn/amzn-drivers/archive/ena_linux_${PV}.tar.gz -> ${P}-linux.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/amzn-drivers-ena_linux_${PV}/kernel/linux/ena"

CONFIG_CHECK="PCI_MSI !CPU_BIG_ENDIAN DIMLIB"
DOCS=(
	README.rst
	RELEASENOTES.md
	ENA_Linux_Best_Practices.rst
)

src_compile() {
	local modlist=( ena=net )
	local modargs=( CONFIG_MODULE_SIG=n BUILD_KERNEL="${KV_FULL}" )
	linux-mod-r1_src_compile
}
