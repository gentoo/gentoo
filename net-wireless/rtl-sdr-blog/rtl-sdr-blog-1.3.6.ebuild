# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="Modified Osmocom drivers with enhancements for RTL-SDR Blog V3 and V4 units"
HOMEPAGE="https://github.com/rtlsdrblog/rtl-sdr-blog"
SRC_URI="https://github.com/rtlsdrblog/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+zerocopy"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.6-disable-static.patch"
	"${FILESDIR}/${PN}-1.3.6-pkgconfig-libdir.patch"
	"${FILESDIR}/${PN}-1.3.6-udev-rules-path.patch"

)

src_prepare() {
	cmake_src_prepare

	# Set proper so file version name
	sed -e '/VERSION_INFO_PATCH_VERSION/ s/git/0/g' -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCVF_VERSION="${PV}"
		-DDETACH_KERNEL_DRIVER="ON"
		-DENABLE_ZEROCOPY="$(usex zerocopy)"
		-DINSTALL_UDEV_RULES="ON"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/rtl_tcp.initd rtl_tcp
	newconfd "${FILESDIR}"/rtl_tcp.confd rtl_tcp
}

pkg_postinst() {
	udev_reload
	elog "Only users in the usb group can capture."
	elog "Just run 'gpasswd -a <USER> usb', then have <USER> re-login."
}

pkg_postrm() {
	udev_reload
}
