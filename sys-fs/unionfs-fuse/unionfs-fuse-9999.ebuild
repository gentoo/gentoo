# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit git-r3

DESCRIPTION="Self-syncing tree-merging file system based on FUSE"

HOMEPAGE="https://github.com/rpodgorny/unionfs-fuse"
EGIT_REPO_URI="https://github.com/rpodgorny/unionfs-fuse.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-fs/fuse:0"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
