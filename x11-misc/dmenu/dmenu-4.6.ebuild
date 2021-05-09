# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit epatch toolchain-funcs

DESCRIPTION="a generic, highly customizable, and efficient menu for the X Window System"
HOMEPAGE="https://tools.suckless.org/dmenu/"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86"
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

src_prepare() {
	sed -i \
		-e 's|^	@|	|g' \
		-e 's|${CC} -o|$(CC) $(CFLAGS) -o|g' \
		-e '/^	echo/d' \
		Makefile || die

	epatch "${FILESDIR}"/${PN}-4.6-gentoo.patch

	epatch_user
}

src_compile() {
	emake CC=$(tc-getCC) \
		"FREETYPEINC=$( $(tc-getPKG_CONFIG) --cflags x11 fontconfig xft 2>/dev/null )" \
		"FREETYPELIBS=$( $(tc-getPKG_CONFIG) --libs x11 fontconfig xft 2>/dev/null )" \
		"XINERAMAFLAGS=$(
			usex xinerama "-DXINERAMA $(
				$(tc-getPKG_CONFIG) --cflags xinerama 2>/dev/null
			)" ''
		)" \
		"XINERAMALIBS=$(
			usex xinerama "$( $(tc-getPKG_CONFIG) --libs xinerama 2>/dev/null)" ''
		)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
