# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/fuse-convmvfs/fuse-convmvfs-0.2.6.ebuild,v 1.1 2011/09/11 20:19:53 sbriesen Exp $

EAPI=4

inherit eutils

DESCRIPTION="FUSE file system to convert filename charset"
HOMEPAGE="http://fuse-convmvfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/fuse"
RDEPEND="${DEPEND}"

src_install() {
	default
	exeinto /sbin
	doexe "${FILESDIR}/mount.convmvfs"
}
