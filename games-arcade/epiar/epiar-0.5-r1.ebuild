# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A space adventure/combat game"
HOMEPAGE="https://sourceforge.net/projects/epiar/"
SRC_URI="mirror://sourceforge/epiar/${P}.0-src.zip"
S="${WORKDIR}"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-image[png]
"
DEPEND="
	${RDEPEND}
	x11-libs/libX11
	virtual/opengl
"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-paths.patch
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-Makefile.linux.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-unsilence-build.patch
	"${FILESDIR}"/${P}-respect-CC.patch
)

src_prepare() {
	default

	append-cflags -fcommon

	sed -i \
		-e "/^CFLAGS/s:-pg -g:${CFLAGS} ${CPPFLAGS} ${LDFLAGS}:" \
		Makefile.linux || die

	sed -i \
		-e "s:GENTOO_DATADIR:/usr/share/${PN}/:" \
		src/main.c || die
}

src_compile() {
	emake \
		-j1 \
		-f Makefile.linux \
		CC="$(tc-getCC)"
}

src_install() {
	dobin epiar

	insinto /usr/share/${PN}
	doins -r missions *.eaf

	keepdir /usr/share/${PN}/plugins
	dodoc AUTHORS ChangeLog README
}
