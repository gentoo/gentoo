# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/firmware"
MY_P="raspberrypi-firmware-${PV}"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD GPL-2 raspberrypi-videocore-bin"
SLOT="0"
KEYWORDS="-* ~arm"
IUSE="+hardfp examples"

RDEPEND="!media-libs/raspberrypi-userland"
DEPEND="${DEPEND}"

S="${WORKDIR}/firmware-${PV}"

RESTRICT="binchecks"

src_install() {
	cd $(usex hardfp hardfp/ "")opt/vc || die

	insinto /opt/vc
	doins -r include
	into /opt
	dobin bin/*
	insopts -m 0755
	insinto "/opt/vc/lib"
	doins -r lib/*

	doenvd "${FILESDIR}"/04${PN}

	if use examples ; then
		insopts -m 0644
		insinto /usr/share/doc/${PF}/examples
		doins -r src/hello_pi
	fi
}
