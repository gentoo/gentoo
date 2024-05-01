# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

COMMIT="cbf8c65d0d792b7dfc02dcaa55d5ec3077464ee6"
DESCRIPTION="Utility to help identify Azure NVMe devices"
HOMEPAGE="https://github.com/Azure/azure-nvme-utils"
#SRC_URI="https://github.com/Azure/${PN}/archive/refs/tags/v${PV}/${P}.tar.gz"
SRC_URI="https://github.com/Azure/${PN}/archive/${COMMIT}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc +lun-fallback"

BDEPEND="
	doc? ( app-text/pandoc )
"

src_configure() {
	local mycmakeargs=(
		-DAZURE_LUN_CALCULATION_BY_NSID_ENABLED=$(usex lun-fallback)
		-DUDEV_RULES_INSTALL_DIR="$(get_udevdir)/rules.d"
		-DPANDOC_EXECUTABLE="$(usex doc "${BROOT}"/usr/bin/pandoc no)"
	)
	cmake_src_configure
}
