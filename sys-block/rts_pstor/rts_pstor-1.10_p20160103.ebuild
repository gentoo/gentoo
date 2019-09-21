# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

GIT_COMMIT="c8313abffe083ac63bf76d2cc90d3edf5b2d1188"

DESCRIPTION="PCI-E RTS5209 card reader driver for Linux"
HOMEPAGE="https://github.com/gexplorer/RTS5209-linux-driver"
SRC_URI="https://github.com/gexplorer/RTS5209-linux-driver/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/linux-sources"
PATCHES=(
	"${FILESDIR}/rts_pstor-makefile.patch"
	"${FILESDIR}/fix-compile-kernel-5.0.0.patch"
)
S="${WORKDIR}/RTS5209-linux-driver-${GIT_COMMIT}"

MODULE_NAMES="rts_pstor(misc/drivers/scsi)"
MODULESD_RTS_PSTOR_ADDITIONS=(
	"# when rts_pstor is installed, blacklist in-kernel driver rtsx_pci"
	"blacklist rtsx_pci"
)
BUILD_TARGETS="default"
BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
CONFIG_CHECK="~!MISC_RTSX_PCI"
ERROR_MISC_RTSX_PCI="CONFIG_MISC_RTSX_PCI: The in-kernel driver rtsx_pci is configured, which may have the same functionality than this driver. To make sure that your kernel loads only rts_pstor, the rtsx_pci module will be blacklisted."

pkg_postinst() {
	elog "This driver is based on code published by Realtek. There is a driver in the kernel named rtsx_pci which"
	elog "should be preferred over this driver - but on some hardware only this driver is functional and rtsx_pci is not."
}
