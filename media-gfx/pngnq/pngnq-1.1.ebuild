# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WANT_AUTOMAKE=1.13
inherit autotools

DESCRIPTION="Pngnq is a tool for quantizing PNG images in RGBA format"
HOMEPAGE="http://pngnq.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD pngnq rwpng"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}"

DOCS=( NEWS README )

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-libpng1{4,5}.patch
)

src_prepare() {
	default

	eautoreconf
}
