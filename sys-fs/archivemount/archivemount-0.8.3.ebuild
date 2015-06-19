# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/archivemount/archivemount-0.8.3.ebuild,v 1.1 2013/11/12 08:59:43 radhermit Exp $

EAPI=5

DESCRIPTION="Mount archives using libarchive and FUSE"
HOMEPAGE="http://www.cybernoia.de/software/archivemount/"
SRC_URI="http://www.cybernoia.de/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-arch/libarchive:=
	sys-fs/fuse"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
