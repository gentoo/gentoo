# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit unpacker udev multilib-minimal systemd

MY_PV_1=$(ver_cut 1)
MY_PV_12=$(ver_cut 1-2)

DESCRIPTION="SDRplay API/HW driver for all RSPs"
HOMEPAGE="https://www.sdrplay.com"
SRC_URI="http://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${PV}.run"

LICENSE="SDRplay"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

DEPEND="virtual/libusb:1
	virtual/udev
	systemd? ( sys-apps/systemd )"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PREBUILT="usr/lib64/libsdrplay_api.so.${MY_PV_12}
usr/lib/libsdrplay_api.so.${MY_PV_12}
usr/bin/sdrplay_apiService"

multilib_src_install_all() {
	doheader -r inc/*.h

	udev_dorules 66-mirics.rules
	udev_reload

	if use systemd; then
		systemd_newunit scripts/sdrplay.service.usr sdrplay.service
	fi

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}

multilib_src_install() {
	if [ "${MULTILIB_ABI_FLAG}" = "abi_x86_32" ]; then
		dolib.so "${S}/i686/libsdrplay_api.so.${MY_PV_12}"
	fi

	if [ "${MULTILIB_ABI_FLAG}" = "abi_x86_64" ]; then
		dolib.so "${S}/x86_64/libsdrplay_api.so.${MY_PV_12}"
	fi

	if multilib_is_native_abi; then
		if [ "${MULTILIB_ABI_FLAG}" = "abi_x86_32" ]; then
			dobin "${S}/i686/sdrplay_apiService"
		elif [ "${MULTILIB_ABI_FLAG}" = "abi_x86_64" ]; then
			dobin "${S}/x86_64/sdrplay_apiService"
		fi
	fi

	dosym libsdrplay_api.so.${MY_PV_12} "/usr/$(get_libdir)/libsdrplay_api.so.${MY_PV_1}"
	dosym libsdrplay_api.so.${MY_PV_1} "/usr/$(get_libdir)/libsdrplay_api.so"
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
