# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Clone of the Rick Dangerous adventure game from the 80's"
HOMEPAGE="http://www.bigorno.net/xrick/"
SRC_URI="http://www.bigorno.net/xrick/${P}.tgz"

LICENSE="GPL-1+ xrick"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
RESTRICT="mirror bindist" # bug #149097

DEPEND="media-libs/libsdl[video]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-exit.patch
	"${FILESDIR}"/${P}-fullscreen.patch
	"${FILESDIR}"/${P}-zlib.patch
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	unpack ./xrick.6.gz
}

src_prepare() {
	default

	sed -i \
		-e "/^run from/d" \
		-e "/data.zip/ s:the directory where xrick is:$(get_libdir)/xrick.:" \
		xrick.6 || die

	sed -i \
		-e "s:data.zip:${EPREFIX}/usr/$(get_libdir)/xrick/data.zip:" \
		src/xrick.c || die
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin xrick

	insinto /usr/$(get_libdir)/xrick
	doins data.zip

	dodoc README KeyCodes
	doman xrick.6

	newicon src/xrickST.ico xrick.ico
	make_desktop_entry xrick xrick /usr/share/pixmaps/xrick.ico
}
