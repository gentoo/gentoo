# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/ubertooth/ubertooth-2014.04.1-r1.ebuild,v 1.2 2014/08/26 01:33:17 zerochaos Exp $

EAPI="5"

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit multilib distutils cmake-utils

HOMEPAGE="http://ubertooth.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+bluez +dfu +specan +python +ubertooth1-firmware +udev"
REQUIRED_USE="dfu? ( python )
		specan? ( python )
		ubertooth1-firmware? ( dfu )
		python? ( || ( dfu specan ) )"
DEPEND="bluez? ( net-wireless/bluez:= )
	>=net-libs/libbtbb-2014.02.2:=
	net-libs/libpcap:="
RDEPEND="${DEPEND}
	specan? ( virtual/libusb:1
		 >=dev-qt/qtgui-4.7.2:4
		>=dev-python/pyside-1.0.2
		>=dev-python/numpy-1.3
		>=dev-python/pyusb-1.0.0_alpha1 )
	dfu? ( virtual/libusb:1
		>=dev-python/pyusb-1.0.0_alpha1 )
	udev? ( virtual/udev )"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/greatscottgadgets/ubertooth.git"
	inherit git-r3
	KEYWORDS=""
	S="${WORKDIR}/${P}/host"
else
	MY_PV=${PV/\./-}
	MY_PV=${MY_PV/./-R}
	S="${WORKDIR}/${PN}-${MY_PV}/host"
	SRC_URI="https://github.com/greatscottgadgets/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.xz"
	#re-add arm keyword after making a lib-only target
	KEYWORDS="~amd64 ~arm ~x86"
fi
DESCRIPTION="An open source wireless development platform suitable for Bluetooth experimentation"

#readd firmware building, but do it right
#USE="-fortran -mudflap -nls -openmp -multilib" crossdev --without-headers --genv 'EXTRA_ECONF="--with-mode=thumb --with-cpu=cortex-m3 --with-float=soft"' -s4 -t arm-cortexm3-eabi

pkg_setup() {
	if use python; then
		python_pkg_setup;
		DISTUTILS_SETUP_FILES=()
		if use dfu; then
			DISTUTILS_SETUP_FILES+=("${S}/python/usb_dfu|setup.py")
			PYTHON_MODNAME="dfu"
		fi
		if use specan; then
			DISTUTILS_SETUP_FILES+=("${S}/python/specan_ui|setup.py")
			PYTHON_MODNAME+=" specan"
		fi
	fi
}

src_prepare() {
	cmake-utils_src_prepare
	use python && distutils_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_enable bluez USE_BLUEZ)
		-DDISABLE_PYTHON=true
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use python && distutils_src_compile
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/${PN}
	cd "${WORKDIR}/${PN}-${MY_PV}" || die
	if [[ ${PV} == "9999" ]] ; then
		ewarn "Firmware isn't available for git releases, we assume you are already"
		ewarn "on the latest and/or can build your own."
	else
	        use ubertooth1-firmware && newins ubertooth-one-firmware-bin/bluetooth_rxtx.dfu ${PN}-one-${PV}-bluetooth_rxtx.dfu
	fi

	if use udev; then
		insinto /lib/udev/rules.d/
		doins "${S}"/lib${PN}/40-${PN}.rules
	fi

	use python && distutils_src_install

	elog "Everyone can read from the ubertooth, but to talk to it"
	elog "your user needs to be in the usb group."
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
