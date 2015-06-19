# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/unionfs-fuse/unionfs-fuse-0.25.ebuild,v 1.1 2012/02/04 01:15:07 sping Exp $

EAPI="2"

DESCRIPTION="Self-syncing tree-merging file system based on FUSE"

HOMEPAGE="http://podgorny.cz/moin/UnionFsFuse"
SRC_URI="http://podgorny.cz/unionfs-fuse/releases/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/fuse"
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/sbin /usr/share/man/man8/ || die "dodir failed"
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"
}
