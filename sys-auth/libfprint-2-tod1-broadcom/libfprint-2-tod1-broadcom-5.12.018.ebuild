# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="Proprietary driver for the fingerprint reader on the Dell Latitude"
HOMEPAGE="https://git.launchpad.net/libfprint-2-tod1-broadcom/"
SRC_URI="http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-broadcom/libfprint-2-tod1-broadcom_${PV}.orig.tar.gz"

LICENSE="Broadcom-tod"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist mirror"
QA_PREBUILT="*"

RDEPEND="
	dev-libs/openssl:0/3
	sys-auth/libfprint[tod(-)]
"

src_install() {
	udev_dorules lib/udev/rules.d/60-libfprint-2-device-broadcom.rules
	exeinto usr/$(get_libdir)/libfprint-2/tod-1/
	doexe usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-2-tod-1-broadcom.so
	mv var "${ED}" || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
