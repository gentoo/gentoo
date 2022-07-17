# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic

DESCRIPTION="DJ Delorie's Ace of Penguins solitaire games"
HOMEPAGE="http://www.delorie.com/store/ace/"
SRC_URI="http://www.delorie.com/store/ace/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libpng:0=
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}/${P}-no-xpm.patch"
	"${FILESDIR}/${P}-libpng15.patch"
	"${FILESDIR}/${P}-gold.patch"
	"${FILESDIR}/${P}-CC.patch"
	"${FILESDIR}/${P}-clang.patch"
	"${FILESDIR}/${P}-gcc10.patch"
	"${FILESDIR}/${P}-malloc.patch"
	"${FILESDIR}/${P}-isgraph-include.patch"
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# Actually fixed upstream but a fair number of commits in CVS(!)
	# since last release, bug #858608. Can drop after 1.4.
	# https://www.delorie.com/bin/cvsweb.cgi/ace/lib/cards.h.diff?r1=1.16&r2=1.17&cvsroot=ace
	filter-lto

	econf \
		--disable-static \
		--program-prefix=ace-
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	dodoc docs/*
	newicon docs/as.gif ${PN}.gif

	cd "${ED}/usr/bin" || die
	local p
	for p in *; do
		make_desktop_entry ${p} "Ace ${p/ace-/}" /usr/share/pixmaps/${PN}.gif
	done
}
