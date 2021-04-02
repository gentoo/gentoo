# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="raspberrypi-firmware-${PV}"
DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/firmware-${PV}"

LICENSE="BSD GPL-2 raspberrypi-videocore-bin"
SLOT="0"
KEYWORDS="-* arm"
IUSE="+hardfp examples"

RDEPEND="!media-libs/raspberrypi-userland"

RESTRICT="binchecks strip"

src_install() {
	cd $(usex hardfp hardfp/ "")opt/vc || die

	insinto /opt/vc
	doins -r include

	into /opt
	dobin bin/*

	insopts -m 0755
	insinto /opt/vc/lib
	doins -r lib/*

	doenvd "${FILESDIR}"/04${PN}

	if use examples ; then
		insopts -m 0644
		docinto examples
		dodoc -r src/hello_pi
	fi
}
