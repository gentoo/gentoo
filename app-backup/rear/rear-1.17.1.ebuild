# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Fully automated disaster recovery, suppors broad variety of backup strategies and scenarios."
HOMEPAGE="http://relax-and-recover.org/"
MY_PV=${PV%.*}
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${MY_PV}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="libressl udev"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-dialup/mingetty
	net-fs/nfs-utils
	sys-apps/gawk
	sys-apps/iproute2
	sys-apps/lsb-release
	sys-apps/util-linux
	sys-block/parted
	sys-boot/syslinux
	virtual/cdrtools
	udev? ( virtual/udev )
"

src_compile () { :; }

src_install () {
	# Deploy udev USB rule and udev will autostart ReaR workflows in case a USB
	# drive with the label 'REAR_000' is connected, which in turn is the
	# default label when running the `rear format` command.
	if use udev ; then
		insinto /lib/udev/rules.d
		doins etc/udev/rules.d/62-${PN}-usb.rules
	fi

	# Copy main script-file and documentation.
	dosbin usr/sbin/${PN}
	doman doc/${PN}.8
	dodoc README

	# Copy configurations files.
	insinto /etc
	doins -r etc/${PN}/

	insinto /usr/share/
	doins -r usr/share/${PN}/
}
