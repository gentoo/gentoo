# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake udev

DESCRIPTION="Library for interfacing with IIO devices"
HOMEPAGE="https://github.com/analogdevicesinc/libiio"
if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/analogdevicesinc/libiio"
	inherit git-r3
else
	SRC_URI="https://github.com/analogdevicesinc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
IUSE="+aio +zeroconf"

RDEPEND="dev-libs/libxml2:=
	virtual/libusb:1=
	aio? ( dev-libs/libaio )
	zeroconf? ( net-dns/avahi[dbus] )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DHAVE_DNS_SD="$(usex zeroconf)"
		-DWITH_AIO="$(usex aio)"
	)
	cmake_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
