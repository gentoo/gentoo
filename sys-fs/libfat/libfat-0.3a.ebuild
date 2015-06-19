# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/libfat/libfat-0.3a.ebuild,v 1.1 2012/07/03 21:24:11 vapier Exp $

EAPI="4"

DESCRIPTION="Support library to access and manipulate FAT12 / FAT16 / FAT32 file systems"
HOMEPAGE="http://libfat.sourceforge.net"
SRC_URI="mirror://sourceforge/libfat/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	sys-fs/fuse"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/fuse-umfuse-fat-0.1
