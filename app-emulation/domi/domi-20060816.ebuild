# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/domi/domi-20060816.ebuild,v 1.3 2010/08/20 17:00:42 jer Exp $

inherit eutils
DESCRIPTION="Scripts for building Xen domains"
HOMEPAGE="http://www.bytesex.org"
EXTRA_VERSION="153213"
SRC_URI="http://dl.bytesex.org/cvs-snapshots/${P}-${EXTRA_VERSION}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="app-emulation/xen-tools
	app-arch/rpm
	sys-block/parted
	sys-apps/yum
	sys-fs/lvm2
	sys-fs/multipath-tools"
# there are some other depends we may need depending on the target system
# these packages aren't in gentoo yet. feel free to submit ebuilds via bugzilla.
# y2pmsh
RESTRICT="test"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	sed -i -e 's:/dev/loop\$:/dev/loop/\$:' "${S}"/domi
	cd "${S}"
	epatch "${FILESDIR}"/fix_install_links.patch
}

src_install() {
	einstall || die
	insinto /etc
	doins "${FILESDIR}"/domi.conf || die
}
