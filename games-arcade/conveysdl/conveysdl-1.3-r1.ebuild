# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop toolchain-funcs

DESCRIPTION="Guide the blob along the conveyer belt collecting the red blobs"
HOMEPAGE="http://www.cloudsprinter.com/software/conveysdl/"
SRC_URI="http://www.cloudsprinter.com/software/conveysdl/${P/-/.}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
RDEPEND=${DEPEND}

S="${WORKDIR}"

src_prepare() {
	default

	# Incomplete readme
	sed -i \
		-e 's:I k:use -nosound to disable sound\n\nI k:' \
		readme || die

	sed -i \
		-e 's:SDL_Mi:SDL_mi:' \
		main.c || die

	eapply \
		"${FILESDIR}"/${P}-arrays.patch \
		"${FILESDIR}"/${P}-speed.patch
}

src_compile() {
	emake main \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} $(sdl-config --cflags) \
			-DDATA_PREFIX=\\\"/usr/share/${PN}/\\\" \
			-DENABLE_SOUND" \
		LDLIBS="-lSDL_mixer $(sdl-config --libs)"
}

src_install() {
	newbin main ${PN}
	insinto /usr/share/${PN}
	doins -r gfx sounds levels
	newicon gfx/jblob.bmp ${PN}.bmp
	make_desktop_entry ${PN} Convey /usr/share/pixmaps/${PN}.bmp
	einstalldocs
}
