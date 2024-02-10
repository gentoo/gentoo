# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="a program for generating photomosaics"
HOMEPAGE="https://www.complang.tuwien.ac.at/schani/metapixel/"
SRC_URI="https://www.complang.tuwien.ac.at/schani/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	>=media-libs/giflib-5:0=
	>=media-libs/libpng-1.4:0=
	media-libs/libjpeg-turbo:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-libpng15.patch
	"${FILESDIR}"/${P}-giflib5.patch
	"${FILESDIR}"/${P}-clang16-build-fix.patch
)

src_prepare() {
	default

	sed -i -e 's:/usr/X11R6:/usr:g' Makefile || die
	sed -i -e 's:ar:$(AR):' rwimg/Makefile || die
}

src_compile() {
	emake AR="$(tc-getAR)" CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}" LDOPTS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}{,-prepare,-imagesize,-sizesort}
	doman ${PN}.1
	dodoc NEWS README
}
