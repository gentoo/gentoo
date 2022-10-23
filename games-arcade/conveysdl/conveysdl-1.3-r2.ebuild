# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Guide the blob along the conveyer belt collecting the red blobs"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${P/-/.}.tar
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-arrays.patch
	"${FILESDIR}"/${P}-audio.patch
	"${FILESDIR}"/${P}-speed.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_compile() {
	tc-export CC

	append-cppflags $($(tc-getPKG_CONFIG) --cflags sdl SDL_mixer || die) \
		-DDATA_PREFIX="'\"${EPREFIX}/usr/share/${PN}/\"'" \
		-DENABLE_SOUND
	append-libs $($(tc-getPKG_CONFIG) --libs sdl SDL_mixer || die)

	emake main LDLIBS="${LIBS}"
}

src_install() {
	newbin main ${PN}

	insinto /usr/share/${PN}
	doins -r gfx levels sounds

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} Convey

	dodoc readme
}
