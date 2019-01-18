# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 savedconfig toolchain-funcs

DESCRIPTION="a generic, highly customizable, and efficient menu for the X Window System"
HOMEPAGE="https://tools.suckless.org/dmenu/"
EGIT_REPO_URI="https://git.suckless.org/dmenu"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="xinerama"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default

	sed -i \
		-e 's|^	@|	|g' \
		-e 's|${CC} -o|$(CC) $(CFLAGS) -o|g' \
		-e '/^	echo/d' \
		Makefile || die

	restore_config config.h
}

src_compile() {
	emake CC=$(tc-getCC) \
		INCS=" \
			$(usex xinerama "-DXINERAMA" '') \
			$(
				$(tc-getPKG_CONFIG) --cflags fontconfig freetype2 x11 xft $(usex xinerama xinerama '')
			)" \
		LIBS=" \
			$(
				$(tc-getPKG_CONFIG) --libs fontconfig x11 xft $(usex xinerama xinerama '')
			)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	save_config config.h
}
