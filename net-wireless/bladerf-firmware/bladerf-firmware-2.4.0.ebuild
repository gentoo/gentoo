# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="bladeRF FX3 firmware images"
HOMEPAGE="https://nuand.com/fx3.php"

#firmware is open source, but uses a proprietary toolchain to build
#automated builds from git are available, but likely unneeded
#http://hoopycat.com/bladerf_builds/
SRC_URI="https://nuand.com/fx3/bladeRF_fw_v${PV}.img"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv x86"
IUSE=""

S="${DISTDIR}"

src_unpack() {
	true
}

src_install() {
	insinto /usr/share/Nuand/bladeRF/
	doins bladeRF_fw_v${PV}.img
}

pkg_postinst() {
	elog "Please remember you have to actually flash this onto"
	elog "your bladerf with the following command:"
	elog "bladeRF-cli -f /usr/share/Nuand/bladeRF/bladeRF_fw_v${PV}.img"
}
