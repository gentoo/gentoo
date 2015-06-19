# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/fuse-zip/fuse-zip-0.2.12.ebuild,v 1.2 2010/08/28 19:24:42 hwoarang Exp $

EAPI=2

DESCRIPTION="FUSE file system to navigate, extract, create and modify ZIP archives based on libzip"
HOMEPAGE="http://code.google.com/p/fuse-zip/"
SRC_URI="http://fuse-zip.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libzip
	sys-fs/fuse"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	# Fix strip than installing fuse-zip
	sed -i -e 's/install -m 755 -s/install -m 755/' Makefile || die "sed failed"
}

src_install() {
	emake INSTALLPREFIX="${D}"/usr install || die "Failed to install"
	prepalldocs
}
