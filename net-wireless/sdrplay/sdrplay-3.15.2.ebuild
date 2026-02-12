# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker udev systemd

MY_PV_1=$(ver_cut 1)
MY_PV_12=$(ver_cut 1-2)

DESCRIPTION="SDRplay API/HW driver for all RSPs"
HOMEPAGE="https://www.sdrplay.com"
SRC_URI="http://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${PV}.run"

S="${WORKDIR}"

LICENSE="SDRplay"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND="virtual/libusb:1
	virtual/udev
	systemd? ( sys-apps/systemd )"

RDEPEND="${DEPEND}"

QA_PREBUILT="usr/lib64/libsdrplay_api.so.${MY_PV_12}
usr/lib/libsdrplay_api.so.${MY_PV_12}
usr/bin/sdrplay_apiService"

src_install() {
	doheader -r inc/*.h

	udev_newrules "${FILESDIR}"/66-sdrplay-${PV}.rules 66-sdrplay.rules

	insinto /etc/udev/hwdb.d
	newins  "${FILESDIR}"/20-sdrplay-${PV}.hwdb 20-sdrplay.hwdb

	if use systemd; then
		systemd_newunit "${FILESDIR}"/sdrplay-${PV}.service sdrplay.service
	fi

	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	dobin "${S}/amd64/sdrplay_apiService"

	dolib.so "${S}/amd64/libsdrplay_api.so.${MY_PV_12}"
	dosym libsdrplay_api.so.${MY_PV_12} "/usr/$(get_libdir)/libsdrplay_api.so.${MY_PV_1}"
	dosym libsdrplay_api.so.${MY_PV_1} "/usr/$(get_libdir)/libsdrplay_api.so"
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
