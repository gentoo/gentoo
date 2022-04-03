# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Pngnq is a tool for quantizing PNG images in RGBA format"
HOMEPAGE="http://pngnq.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD pngnq rwpng"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-libpng14.patch
	"${FILESDIR}"/${PN}-1.0-libpng15.patch
	"${FILESDIR}"/${PN}-1.0-Wimplicit-function-declaration.patch
)

src_prepare() {
	default
	eautoreconf
}
