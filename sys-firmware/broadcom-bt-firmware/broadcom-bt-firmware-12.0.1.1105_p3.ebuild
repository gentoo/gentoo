# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Broadcom Bluetooth firmware"
HOMEPAGE="https://github.com/winterheart/broadcom-bt-firmware"
SRC_URI="https://github.com/winterheart/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="broadcom_bcm20702 MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

src_install() {
	insinto /lib/firmware
	doins -r brcm
}
