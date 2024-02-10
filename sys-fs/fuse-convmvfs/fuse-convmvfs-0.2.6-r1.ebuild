# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FUSE file system to convert filename charset"
HOMEPAGE="http://fuse-convmvfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-fs/fuse:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	default
	exeinto /sbin
	doexe "${FILESDIR}/mount.convmvfs"
}
