# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Retro-style, abstract, 2D shooter"
HOMEPAGE="https://transcend.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/Transcend_${PV}_UnixSource.tar.gz"
S="${WORKDIR}/Transcend_${PV}_UnixSource"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/freeglut
	media-libs/portaudio
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-system-portaudio.patch
)

src_prepare() {
	default

	rm -r ${PN^}/portaudio || die

	sed -e "s|\"levels\"|\"${EPREFIX}/usr/share/${PN}/levels\"|" \
		-i ${PN^}/game/{LevelDirectoryManager,game}.cpp || die
}

src_configure() {
	cd ${PN^} || die
	platformSelection=1 ./configure || die
}

src_compile() {
	tc-export PKG_CONFIG

	local emakeargs=(
		GXX="$(tc-getCXX)"
		OPTIMIZE_FLAG="${CXXFLAGS}"
		LINK_FLAGS="${LDFLAGS}"
	)

	emake -C ${PN^}/game "${emakeargs[@]}"
}

src_install() {
	cd ${PN^} || die

	newbin game/${PN^} ${PN}

	insinto /usr/share/${PN}
	doins -r levels

	dodoc doc/{how_to_play.txt,changeLog.txt}

	make_desktop_entry ${PN} ${PN^} applications-games
}
