# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Scripts to build Ganeti VMs with debootstrap"
HOMEPAGE="http://www.ganeti.org/"
SRC_URI="http://downloads.ganeti.org/instance-debootstrap/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	${DEPEND}
	>=sys-apps/coreutils-6.10-r1
	app-arch/dpkg
	app-arch/dump
	app-emulation/ganeti
	dev-util/debootstrap
	sys-apps/util-linux
	sys-fs/e2fsprogs
	sys-fs/multipath-tools
"

src_prepare() {
	default

	sed -i -e 's|AC_MSG_ERROR|AC_MSG_WARN|g' configure.ac || die
	sed -i -e 's|COPYING||g' Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --docdir=/usr/share/doc/${P}
}

src_install() {
	default

	insinto /etc/ganeti/instance-debootstrap/hooks
	doins examples/hooks/*
}
