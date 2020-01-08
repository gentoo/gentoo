# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

DESCRIPTION="Aquantia AQC multigigabit NIC linux driver (atlantic) - development preview"
HOMEPAGE="https://github.com/Aquantia/AQtion"

COMMIT_ID="e024a859ea828ced78db310328db90dbedea837a"
SRC_URI="https://github.com/Aquantia/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="lro"

DEPEND="virtual/linux-sources"

S="${WORKDIR}/${PN}-${COMMIT_ID}"

MODULE_NAMES="atlantic(drivers/net/ethernet/aquantia/atlantic:${S})"
BUILD_TARGETS="all"
CONFIG_CHECK="~!AQTION ~PTP_1588_CLOCK ~CRC_ITU_T"

DOCS=(
	README.md
	README.txt
)

pkg_setup() {
	use lro && CONFIG_CHECK+=" ~!CONFIG_BRIDGE"
	linux-mod_pkg_setup
}

src_prepare() {
	default

	if ! use lro; then
		sed -r -i -e 's/(#define AQ_CFG_IS_LRO_DEF[[:space:]]+)[[:digit:]]+([[:alpha:]]*)/\10\2/' \
			aq_cfg.h || die
	fi
}

src_compile() {
	KDIR="${KERNEL_DIR}" linux-mod_src_compile
}

src_install() {
	KDIR="${KERNEL_DIR}" linux-mod_src_install
	dodoc "${DOCS[@]}"
}
