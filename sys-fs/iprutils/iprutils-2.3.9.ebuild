# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

S=${WORKDIR}/${PN}
DESCRIPTION="IBM's tools for support of the ipr SCSI controller"
SRC_URI="mirror://sourceforge/iprdd/${P}-src.tgz"
HOMEPAGE="http://sourceforge.net/projects/iprdd/"

SLOT="0"
LICENSE="IBM"
KEYWORDS="ppc ppc64"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.4-r5
	>=sys-apps/pciutils-2.1.11-r1
	>=sys-fs/sysfsutils-1.3.0
	virtual/udev"

RDEPEND="${DEPEND}
	virtual/logger"

src_install () {
	make INSTALL_MOD_PATH="${D}" install || die
	dodoc ChangeLog

	newinitd "${FILESDIR}"/iprinit iprinit
	newinitd "${FILESDIR}"/iprupdate iprupdate
	newinitd "${FILESDIR}"/iprdump iprdump
}

pkg_postinst() {
	einfo "This package also contains several init.d files. "
	einfo "You should add them to your default runlevels as follows:"
	einfo "rc-update add iprinit default"
	einfo "rc-update add iprdump default"
	einfo "rc-update add iprupdate default"
	ebeep 5
}
