# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/wdfs/wdfs-1.4.2-r1.ebuild,v 1.3 2015/06/26 08:53:23 ago Exp $

EAPI="5"

inherit eutils

DESCRIPTION="WebDAV filesystem with special features for accessing subversion repositories"
HOMEPAGE="http://noedler.de/projekte/wdfs/"
SRC_URI="http://noedler.de/projekte/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=net-libs/neon-0.24.7
	 >=sys-fs/fuse-2.5
	 dev-libs/glib:2"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-Waddress.patch"
}
