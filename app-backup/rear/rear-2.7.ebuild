# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature udev

DESCRIPTION="Relax-and-Recover is a setup-and-forget bare metal disaster recovery solution"
HOMEPAGE="http://relax-and-recover.org/ https://github.com/rear/rear/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="udev"

RDEPEND="
	app-cdr/cdrtools
	app-shells/bash
	net-dialup/mingetty
	net-fs/nfs-utils
	sys-apps/gawk
	sys-apps/iproute2
	sys-apps/lsb-release
	sys-apps/sed
	sys-apps/util-linux
	sys-block/parted
	sys-boot/syslinux
	udev? ( virtual/udev )
"

src_compile() { :; }

src_install() {
	emake DESTDIR="${D}" install

	if use udev ; then
		einfo "Deploy udev USB rule and udev will autostart ReaR workflows in case a USB"
		einfo "drive with the label 'REAR_000' is connected, which in turn is the"
		einfo "default label when running the \`rear format\` command."
		udev_dorules etc/udev/rules.d/62-${PN}-usb.rules
	fi

	keepdir /etc/rear
	keepdir /var/lib/rear
	keepdir /var/log/rear
}

pkg_postinst() {
	if use udev; then
		udev_reload
	fi

	optfeature "saving backups on smb/cifs servers" net-fs/cifs-utils
	optfeature "encrypting backups" dev-libs/openssl
}

pkg_postrm() {
	if use udev; then
		udev_reload
	fi
}
