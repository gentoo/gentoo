# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="FUSE file system to navigate, extract, create and modify ZIP archives based on libzip"
HOMEPAGE="https://bitbucket.org/agalanin/fuse-zip"
SRC_URI="https://fuse-zip.googlecode.com/files/${P}.tar.gz"

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
