# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop edos2unix toolchain-funcs

DESCRIPTION="Tow Bowl Tactics is a game based on Games Workshop's Blood Bowl"
HOMEPAGE="http://www.towbowltactics.com/index_en.html"
SRC_URI="http://www.towbowltactics.com/download/tbt.${PV}.src.zip"
S="${WORKDIR}"/tbt/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libxml2
	media-libs/smpeg
	media-libs/libsdl[sound,video]
	media-libs/sdl-net
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	cd  .. || die

	edos2unix $(find src -type f) config.xml

	default

	sed -i \
	    -e "/^TBTHOME/ s:/.*:/usr/share/tbt:" \
		src/Makefile || die
	sed -i \
		-e "/tbt.ico/ s:\"\./:TBTHOME \"/:" \
		src/Main.cpp || die
	sed -i \
		-e "s:TBTHOME \"/config.xml:\"/etc/tbt/config.xml:g" \
		src/global.h || die
}

src_configure() {
	tc-export CXX
}

src_install() {
	dobin tbt

	dodir /usr/share/tbt
	cp -r ../data ../tbt.ico "${ED}"/usr/share/tbt || die

	insinto /etc/tbt
	doins ../config.xml

	newicon ../data/images/panel/turn.png ${PN}.png
	make_desktop_entry tbt "Tow Bowl Tactics"
}
