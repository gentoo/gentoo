# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit multilib distutils-r1 cmake-utils udev

HOMEPAGE="http://ubertooth.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+bluez +specan static-libs +pcap +ubertooth1-firmware +udev"
REQUIRED_USE="specan? ( ${PYTHON_REQUIRED_USE} )"
DEPEND="bluez? ( net-wireless/bluez:= )
	>=net-libs/libbtbb-${PV}:=[static-libs?]
	pcap? ( net-libs/libbtbb[pcap] )
	specan? ( ${PYTHON_DEPS} )
	static-libs? ( dev-libs/libusb[static-libs] )
	virtual/libusb:1="
RDEPEND="${DEPEND}
	specan? ( >=dev-qt/qtgui-4.7.2:4
		>=dev-python/pyside-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.3[${PYTHON_USEDEP}] )
	udev? ( virtual/udev )"

MY_PV=${PV/\./-}
MY_PV=${MY_PV/./-R}
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/greatscottgadgets/ubertooth.git"
	inherit git-r3
	KEYWORDS=""
	S="${WORKDIR}/${P}/host"
else
	S="${WORKDIR}/${PN}-${MY_PV}/host"
	SRC_URI="https://github.com/greatscottgadgets/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi
DESCRIPTION="open source wireless development platform suitable for Bluetooth experimentation"

#readd firmware building, but do it right
#USE="-fortran -mudflap -nls -openmp -multilib" crossdev --without-headers --genv 'EXTRA_ECONF="--with-mode=thumb --with-cpu=cortex-m3 --with-float=soft"' -s4 -t arm-cortexm3-eabi

src_prepare() {
	cmake-utils_src_prepare
	if use specan; then
		pushd python/specan_ui || die
		distutils-r1_src_prepare
		popd
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable bluez USE_BLUEZ)
		$(cmake-utils_use pcap USE_PCAP)
		$(cmake-utils_use static-libs BUILD_STATIC_LIB)
		$(cmake-utils_use_enable udev INSTALL_UDEV_RULES)
		-DENABLE_PYTHON=false
	)
	if use udev; then
		mycmakeargs+=(
			-DUDEV_RULES_GROUP=usb
			-DUDEV_RULES_PATH="$(get_udevdir)/rules.d"
		)
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use specan; then
		pushd python/specan_ui || die
		distutils-r1_src_compile
		popd
	fi
}

src_install() {
	cmake-utils_src_install

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

	if use specan; then
		pushd python/specan_ui || die
		distutils-r1_src_install
		popd
	fi

	elog "Everyone can read from the ubertooth, but to talk to it"
	elog "your user needs to be in the usb group."
}
