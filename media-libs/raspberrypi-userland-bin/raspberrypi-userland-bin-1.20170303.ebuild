# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib vcs-snapshot

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/firmware"
MY_P="raspberrypi-firmware-${PV}"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD GPL-2 raspberrypi-videocore-bin"
SLOT="0"
KEYWORDS="~arm -*"
IUSE="+hardfp examples"

RDEPEND="!media-libs/raspberrypi-userland"
DEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

RESTRICT="binchecks"

src_prepare() {
	rm {,hardfp/}opt/vc/LICENCE || die
}

src_install() {
	cd $(usex hardfp hardfp/ "")opt/vc || die

	insinto /opt/vc
	doins -r include
	into /opt
	dobin bin/*
	dobin sbin/*
	insopts -m 0755
	insinto "/opt/vc/$(get_libdir)"
	doins -r lib/*

	doenvd "${FILESDIR}"/04${PN}

	if use examples ; then
		insopts -m 0644
		insinto /usr/share/doc/${PF}/examples
		doins -r src/hello_pi
	fi
}
