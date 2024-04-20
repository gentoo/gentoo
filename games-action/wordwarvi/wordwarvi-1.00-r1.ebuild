# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Retro side-scrolling shoot'em up based on the editor war story"
HOMEPAGE="https://wordwarvi.sourceforge.net"
SRC_URI="mirror://sourceforge/wordwarvi/${P}.tar.gz"

LICENSE="GPL-2+ CC-BY-2.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="portaudio"

RDEPEND="
	x11-libs/gtk+:2
	portaudio? (
		media-libs/libvorbis
		>=media-libs/portaudio-19_pre1
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-sound.patch
)

src_prepare() {
	default

	sed -i \
		-e "/^WITHAUDIO/s/yes/$(use portaudio && echo yes || echo no)/" \
		Makefile || die
	sed -i \
		-e "s:GENTOO_DATADIR:/usr/share/${PN}:" \
		wwviaudio.c || die
}

src_compile() {
	tc-export BUILD_CC CC PKG_CONFIG

	emake \
		PREFIX="/usr" \
		DATADIR="/usr/share/${PN}" \
		MANDIR="/usr/share/man"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		DATADIR="/usr/share/${PN}" \
		MANDIR="/usr/share/man" \
		install

	if ! use portaudio ; then
		rm -rf "${ED}/usr/share" || die
	fi

	dodoc README AUTHORS changelog.txt AAA_HOW_TO_MAKE_NEW_LEVELS.txt
	newicon icons/wordwarvi_icon_128x128.png ${PN}.png
	make_desktop_entry ${PN} "Word War vi"
}
