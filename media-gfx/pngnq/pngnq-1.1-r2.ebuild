# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Pngnq is a tool for quantizing PNG images in RGBA format"
HOMEPAGE="https://pngnq.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="BSD pngnq rwpng"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="media-libs/libpng:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-libpng14.patch
	"${FILESDIR}"/${PN}-1.0-libpng15.patch
	"${FILESDIR}"/${PN}-1.0-Wimplicit-function-declaration.patch
	"${FILESDIR}"/${PN}-1.1-autoconf-quoting.patch
	"${FILESDIR}"/${PN}-1.1-gcc14-build-fix.patch
)

src_prepare() {
	default
	eautoreconf
}
