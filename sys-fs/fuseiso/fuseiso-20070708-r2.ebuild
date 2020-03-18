# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fuse module to mount ISO9660"
HOMEPAGE="https://sourceforge.net/projects/fuseiso"
SRC_URI="http://superb-dca2.dl.sourceforge.net/project/fuseiso/fuseiso/20070708/fuseiso-20070708.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND="sys-fs/fuse:0=
	sys-libs/zlib
	dev-libs/glib:2"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )
PATCHES=( ${FILESDIR}/${P}-largeiso.patch ${FILESDIR}/${P}-fix-typo.patch )
