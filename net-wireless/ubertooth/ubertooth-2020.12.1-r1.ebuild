# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

HOMEPAGE="http://ubertooth.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+bluez static-libs +ubertooth1-firmware +udev"

DEPEND="bluez? ( net-wireless/bluez:= )
	>=net-libs/libbtbb-${PV}:=[static-libs?]
	static-libs? ( dev-libs/libusb[static-libs] )
	virtual/libusb:1"
RDEPEND="${DEPEND}
	udev? ( virtual/udev )"

MY_PV=${PV/\./-}
MY_PV=${MY_PV/./-R}
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/greatscottgadgets/ubertooth.git"
	inherit git-r3
	S="${WORKDIR}/${P}/host"
else
	S="${WORKDIR}/${PN}-${MY_PV}/host"
	SRC_URI="https://github.com/greatscottgadgets/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi
DESCRIPTION="open source wireless development platform suitable for Bluetooth experimentation"

#readd firmware building, but do it right
#USE="-fortran -mudflap -nls -openmp -multilib" crossdev --without-headers --genv 'EXTRA_ECONF="--with-mode=thumb --with-cpu=cortex-m3 --with-float=soft"' -s4 -t arm-cortexm3-eabi

src_configure() {
	local mycmakeargs=(
		-DUSE_BLUEZ=$(usex bluez)
		-DBUILD_STATIC_LIB=$(usex static-libs)
		-DINSTALL_UDEV_RULES=$(usex udev)
		-DENABLE_PYTHON=false
	)
	if use udev; then
		mycmakeargs+=(
			-DUDEV_RULES_GROUP=usb
			-DUDEV_RULES_PATH="$(get_udevdir)/rules.d"
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}
	pushd "${WORKDIR}/${PN}-${MY_PV}" || die
	if [[ ${PV} == "9999" ]] ; then
		ewarn "Firmware isn't available for git releases, we assume you are already"
		ewarn "on the latest and/or can build your own."
	else
		use ubertooth1-firmware && newins ubertooth-one-firmware-bin/bluetooth_rxtx.dfu ${PN}-one-${PV}-bluetooth_rxtx.dfu
		use ubertooth1-firmware && newins ubertooth-one-firmware-bin/bluetooth_rx_only.dfu ${PN}-one-${PV}-bluetooth_rx_only.dfu
	fi
	popd

	elog "Everyone can read from the ubertooth, but to talk to it"
	elog "your user needs to be in the usb group."
}

pkg_postinst() {
	use udev && udev_reload
}

pkg_postrm() {
	use udev && udev_reload
}
