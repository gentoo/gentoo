# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eapi8-dosym toolchain-funcs xdg

DESCRIPTION="Clone of Super Monkey Ball using SDL/OpenGL"
HOMEPAGE="https://neverball.org"
SRC_URI="https://neverball.org/${P}.tar.gz"

LICENSE="GPL-2+ IJG"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="nls"
RESTRICT="test" # not a test suite, only starts ./neverball

DEPEND="
	dev-games/physfs
	media-libs/libpng:=
	media-libs/libsdl2[joystick,opengl,sound,video]
	media-libs/libvorbis
	media-libs/sdl2-ttf
	virtual/jpeg
	virtual/opengl
	nls? ( virtual/libintl )"
RDEPEND="
	${DEPEND}
	media-fonts/dejavu
	media-fonts/wqy-microhei"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-10.patch
)

src_prepare() {
	default

	# adjust man page for namespaced mapc executable (bug #50538)
	sed -i "s/mapc/${PN}-mapc/;s/MAPC/${PN^^}-MAPC/;1s/1/6/" dist/mapc.1 || die
}

src_compile() {
	tc-export CC CXX

	local emakeargs=(
		DATADIR="${EPREFIX}"/usr/share/${PN}
		LOCALEDIR="${EPREFIX}"/usr/share/locale
		ENABLE_NLS=$(usex nls 1 0)
		CFLAGS="${CFLAGS}"
		CPPFLAGS="${CPPFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
	)
	emake "${emakeargs[@]}"
}

src_install() {
	dobin neverball neverputt
	newbin mapc ${PN}-mapc

	doman dist/{neverball,neverputt}.6
	newman dist/mapc.1 neverball-mapc.6

	insinto /usr/share/${PN}
	doins -r data/.

	# unbundle fonts
	dosym8 -r /usr/share/{fonts/dejavu,${PN}/ttf}/DejaVuSans-Bold.ttf
	dosym8 -r /usr/share/{fonts/wqy-microhei,${PN}/ttf}/wqy-microhei.ttc

	insinto /usr/share
	[[ -d locale ]] && doins -r locale

	dodoc README.md doc/{authors.txt,manual.txt,release-notes.md}

	local name res
	for name in ball putt; do
		for res in 16 32 64 128 256; do
			newicon -s ${res} dist/never${name}_${res}.png never${name}.png
		done
	done
	domenu dist/{neverball,neverputt}.desktop
}
