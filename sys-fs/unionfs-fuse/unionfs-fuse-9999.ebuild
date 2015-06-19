# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/unionfs-fuse/unionfs-fuse-9999.ebuild,v 1.1 2015/01/11 21:01:52 sping Exp $

EAPI="5"

inherit git-r3

DESCRIPTION="Self-syncing tree-merging file system based on FUSE"

HOMEPAGE="https://github.com/rpodgorny/unionfs-fuse"
EGIT_REPO_URI="https://github.com/rpodgorny/unionfs-fuse.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-fs/fuse"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install || die "emake install failed"
}
