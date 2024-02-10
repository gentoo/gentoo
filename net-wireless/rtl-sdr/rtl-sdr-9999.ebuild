# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Turns your Realtek RTL2832 based DVB dongle into a SDR receiver"
HOMEPAGE="https://sdr.osmocom.org/trac/wiki/rtl-sdr"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.osmocom.org/${PN}"
else
	#COMMIT="142325a93c6ad70f851f43434acfdf75e12dfe03"
	#SRC_URI="https://github.com/osmocom/rtl-sdr/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	#S="${WORKDIR}/${PN}-${COMMIT}"
	SRC_URI="https://github.com/osmocom/rtl-sdr/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="+zerocopy"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/rtl-sdl-0.6.0_p2020802-fix-pkgconfig-libdir.patch
)

src_configure() {
	#the udev rules are 666, we don't want that
	local mycmakeargs=(
		-DINSTALL_UDEV_RULES=OFF
		-DDETACH_KERNEL_DRIVER=ON
		-DENABLE_ZEROCOPY="$(usex zerocopy)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/rtl_tcp.initd rtl_tcp
	newconfd "${FILESDIR}"/rtl_tcp.confd rtl_tcp
}

pkg_postinst() {
	elog "Only users in the usb group can capture."
	elog "Just run 'gpasswd -a <USER> usb', then have <USER> re-login."
}
