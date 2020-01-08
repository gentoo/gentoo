# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib

DESCRIPTION="turns your Realtek RTL2832 based DVB dongle into a SDR receiver"
HOMEPAGE="http://sdr.osmocom.org/trac/wiki/rtl-sdr"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://git.osmocom.org/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/steve-m/librtlsdr/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}"/librtlsdr-${PV}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_configure() {
	#the udev rules are 666, we don't want that
	mycmakeargs=(
		-DINSTALL_UDEV_RULES=OFF
		-DDETACH_KERNEL_DRIVER=ON
		-DLIB_INSTALL_DIR=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}"/rtl_tcp.initd rtl_tcp
	newconfd "${FILESDIR}"/rtl_tcp.confd rtl_tcp
}

pkg_postinst() {
	elog "Only users in the usb group can capture."
	elog "Just run 'gpasswd -a <USER> usb', then have <USER> re-login."
}
