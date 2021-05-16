# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A tool for decompressing data compressed with PKWARE Data Compression Library"
HOMEPAGE="https://github.com/twogood/dynamite https://sourceforge.net/projects/synce/"
SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.1_p20120512-dynamite-bootstrap.patch
)

src_prepare() {
	default
	./bootstrap || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc ChangeLog README

	find "${ED}" -name '*.la' -delete || die
}
