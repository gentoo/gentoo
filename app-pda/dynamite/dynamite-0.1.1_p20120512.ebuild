# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools eutils

DESCRIPTION="A tool for decompressing data compressed with PKWARE Data Compression Library"
HOMEPAGE="https://github.com/twogood/dynamite https://sourceforge.net/projects/synce/"
SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"

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
