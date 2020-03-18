# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Self-syncing tree-merging file system based on FUSE"

HOMEPAGE="https://github.com/rpodgorny/unionfs-fuse"
SRC_URI="https://github.com/rpodgorny/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE=""

DEPEND="sys-fs/fuse:0"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
