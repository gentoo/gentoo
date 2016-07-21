# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
DESCRIPTION="Scripts for building Xen domains"
HOMEPAGE="http://www.bytesex.org"
EXTRA_VERSION="153213"
SRC_URI="http://dl.bytesex.org/cvs-snapshots/${P}-${EXTRA_VERSION}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="
	app-emulation/xen-tools
	app-arch/rpm
	sys-block/parted
	sys-apps/yum
	sys-fs/lvm2
	sys-fs/multipath-tools
"
# there are some other depends we may need depending on the target system
# these packages aren't in gentoo yet. feel free to submit ebuilds via bugzilla.
# y2pmsh
RESTRICT="test"

S=${WORKDIR}/${PN}

src_configure() {
	sed -i -e 's@/usr/local@/usr@' "${S}"/Makefile
	sed -i -e 's:/dev/loop\$:/dev/loop/\$:' "${S}"/domi
}

src_install() {
	emake DESTDIR="${D}" install
	insinto /etc
	doins "${FILESDIR}"/domi.conf || die
}
