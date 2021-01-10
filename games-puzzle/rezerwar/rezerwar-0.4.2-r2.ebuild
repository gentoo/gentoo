# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Puzzle game like the known tetromino and the average pipe games"
HOMEPAGE="https://tamentis.com/projects/rezerwar/"
SRC_URI="https://tamentis.com/projects/rezerwar/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-mixer[vorbis]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-CC.patch
	"${FILESDIR}"/${P}-gcc10.patch
)

src_prepare() {
	default
	sed -i \
		-e '/check_sdl$/d' \
		-e 's/-O2 //' \
		configure \
		|| die 'sed failed'
	sed -i \
		-e '/CC.*OBJECTS/s:$(CC):$(CC) $(LDFLAGS):' \
		mkfiles/Makefile.src \
		|| die "sed failed"
}

src_configure() {
	tc-export CC

	SDLCONFIG=sdl-config \
	TARGET_BIN="${EPREFIX}/usr/bin" \
	TARGET_DOC="${EPREFIX}/usr/share/doc/${PF}" \
	TARGET_DATA="${EPREFIX}/usr/share/${PN}" \
		./configure || die "configure failed"
	sed -i \
		-e '/TARGET_DOC/d' \
		Makefile \
		|| die "sed failed"
}

src_install() {
	dodir /usr/bin
	default
	dodoc doc/{CHANGES,README,TODO}
	make_desktop_entry rezerwar Rezerwar
}
