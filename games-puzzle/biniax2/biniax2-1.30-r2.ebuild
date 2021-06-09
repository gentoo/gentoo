# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Logic game with arcade and tactics modes"
HOMEPAGE="http://biniax.com/"
SRC_URI="http://www.tuzsuzov.com/biniax/${P}-fullsrc.tar.gz"
S="${WORKDIR}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-dotfiles.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	rm data/Thumbs.db || die

	sed -i "s|data/|/usr/share/${PN}/|" desktop/{gfx,snd}.c || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r data/.

	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} Biniax-2
}
