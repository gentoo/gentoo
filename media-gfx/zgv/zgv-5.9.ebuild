# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A svgalib console image viewer"
HOMEPAGE="http://www.svgalib.org/rus/zgv/"
SRC_URI="http://www.svgalib.org/rus/zgv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

RDEPEND="
	media-libs/libpng
	>=media-libs/svgalib-1.4.2
	>=media-libs/tiff-3.5.5
	sys-apps/gawk
	>=sys-libs/zlib-1.1.4
	virtual/jpeg
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile-QA.patch
	"${FILESDIR}"/${P}-cmyk-yccl-fix.diff
	"${FILESDIR}"/${P}-libpng15.patch
)

src_prepare() {
	sed -i -e "/^CFLAGS=/s:=.*:=${CFLAGS}:" config.mk || die
	sed -i -e 's:$(RM):echo:' doc/Makefile || die
	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/bin /usr/share/info /usr/share/man/man1

	emake \
		PREFIX="${ED}"/usr \
		INFODIR="${ED}"/usr/share/info \
		MANDIR="${ED}"/usr/share/man/man1 \
		install

	dodoc AUTHORS ChangeLog INSTALL NEWS README* SECURITY TODO

	# Fix info files
	cd "${D}"/usr/share/info
	rm dir* || die
	mv zgv zgv.info || die
	for i in 1 2 3 4 ; do
		mv zgv-$i zgv.info-$i || die
	done
}
