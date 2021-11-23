# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="SDL based graphical file browser"
HOMEPAGE="https://www.determinate.net/webdata/seg/tdfsb.html"
SRC_URI="https://www.determinate.net/webdata/data/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

DEPEND="media-libs/freeglut
	media-libs/sdl-image
	media-libs/smpeg
	virtual/glu
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-asneeded.patch
	"${FILESDIR}"/${P}-debugging.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-void-return.patch
)

src_prepare() {
	default

	sed -i -e "s|-O2|${CFLAGS} ${LDFLAGS}|" \
		-e "s:gcc:$(tc-getCC):" "${S}"/compile.sh || die
}

src_compile() {
	./compile.sh || die "compile failed"
}

src_install() {
	dobin tdfsb
	dodoc ChangeLog README
}
