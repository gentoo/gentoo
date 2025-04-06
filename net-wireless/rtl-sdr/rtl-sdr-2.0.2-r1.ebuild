# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="Turns your Realtek RTL2832 based DVB dongle into a SDR receiver"
HOMEPAGE="https://sdr.osmocom.org/trac/wiki/rtl-sdr"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.osmocom.org/${PN}"
else
	SRC_URI="https://github.com/osmocom/rtl-sdr/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ppc64 ~riscv ~sparc x86"
fi

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="+zerocopy"

DEPEND="virtual/libusb:1"
RDEPEND="
	${DEPEND}
	!net-wireless/rtl-sdr-blog
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.2-disable-static.patch"
	"${FILESDIR}/${PN}-2.0.2-pkgconfig-libdir.patch"
	"${FILESDIR}/${PN}-2.0.2-udev-rules-path.patch"

)

src_configure() {
	local mycmakeargs=(
		-DDETACH_KERNEL_DRIVER="ON"
		-DENABLE_ZEROCOPY="$(usex zerocopy)"
		-DINSTALL_UDEV_RULES="ON"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/rtl_tcp.initd-r1 rtl_tcp
	newconfd "${FILESDIR}"/rtl_tcp.confd-r1 rtl_tcp
}

pkg_postinst() {
	udev_reload
	elog "Only users in the usb group can capture."
	elog "Just run 'gpasswd -a <USER> usb', then have <USER> re-login."
}

pkg_postrm() {
	udev_reload
}
