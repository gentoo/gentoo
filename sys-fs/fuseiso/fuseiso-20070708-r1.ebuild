# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Fuse module to mount ISO9660"
HOMEPAGE="https://sourceforge.net/projects/fuseiso"
SRC_URI="http://superb-dca2.dl.sourceforge.net/project/fuseiso/fuseiso/20070708/fuseiso-20070708.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="sys-fs/fuse
	sys-libs/zlib
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	epatch "${FILESDIR}/${P}-largeiso.patch"
	epatch "${FILESDIR}/${P}-fix-typo.patch" # bug #482078
	epatch_user
}
