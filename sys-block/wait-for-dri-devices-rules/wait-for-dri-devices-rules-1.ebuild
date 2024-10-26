# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit readme.gentoo-r1 udev

DESCRIPTION="Udev and systemd rules to wait for dri devices"
HOMEPAGE="https://gitlab.com/pachoramos/wait-for-dri-devices-rules"
SRC_URI="https://gitlab.com/pachoramos/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	sys-apps/systemd
	virtual/udev
"

DOC_CONTENTS="
	Feel free to modify
	/etc/systemd/system/display-manager.service.d/10-wait-for-dri-devices.conf
	according to your needed cards."

src_install() {
	udev_dorules udev/rules.d/99-systemd-dri-devices.rules
	insinto /etc/systemd/system/display-manager.service.d/10-wait-for-dri-devices.conf
	doins systemd/system/display-manager.service.d/10-wait-for-dri-devices.conf
	einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	udev_reload
	readme.gentoo_print_elog
}

pkg_postrm() {
	udev_reload
}
