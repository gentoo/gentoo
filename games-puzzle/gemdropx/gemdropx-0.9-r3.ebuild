# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Puzzle game where it's your job to clear the screen of gems"
HOMEPAGE="http://www.newbreedsoftware.com/gemdropx/"
SRC_URI="ftp://ftp.tuxpaint.org/unix/x/gemdropx/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-mixer[mod]"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i \
		-e 's/$(CFLAGS) -o/$(LDFLAGS) -o/' \
		Makefile || die
	rm -r data/images/.xvpics || die
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCC)"
		DATA_PREFIX="${EPREFIX}/usr/share/${PN}"
		XTRA_FLAGS="${CFLAGS}"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r data/.

	dodoc AUTHORS.txt CHANGES.txt ICON.txt README.txt TODO.txt

	newicon data/images/${PN}-icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Gem Drop X"
}
