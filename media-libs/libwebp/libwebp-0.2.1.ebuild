# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libwebp/libwebp-0.2.1.ebuild,v 1.10 2014/01/16 16:00:38 blueness Exp $

EAPI=4
inherit eutils

DESCRIPTION="A lossy image compression format"
HOMEPAGE="http://code.google.com/p/webp/"
SRC_URI="http://webp.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="experimental static-libs"

RDEPEND="media-libs/libpng:0
	media-libs/tiff:0
	virtual/jpeg"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog doc/*.txt NEWS README*"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-silent-rules \
		$(use_enable experimental) \
		--enable-experimental-libwebpmux
}

src_install() {
	default
	prune_libtool_files
}
