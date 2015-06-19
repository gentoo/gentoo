# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/dynamite/dynamite-0.1.1_p20120512.ebuild,v 1.1 2012/05/12 17:45:13 ssuominen Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="A tool (and library) for decompressing data compressed with PKWARE Data Compression Library"
HOMEPAGE="https://github.com/twogood/dynamite http://sourceforge.net/projects/synce/"
SRC_URI="http://dev.gentoo.org/~ssuominen/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-bootstrap.patch
	./bootstrap
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog README

	find "${ED}" -name '*.la' -exec rm -f {} +
}
