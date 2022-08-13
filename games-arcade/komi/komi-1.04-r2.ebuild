# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Komi the Space Frog - a simple SDL game"
HOMEPAGE="http://komi.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/komi/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	tc-export CC

	append-cppflags $($(tc-getPKG_CONFIG) --cflags sdl SDL_mixer || die) \
		-DDATAPATH="'\"${EPREFIX}/usr/share/${PN}/\"'"
	append-libs $($(tc-getPKG_CONFIG) --libs sdl SDL_mixer || die)

	# simpler to use implicit rules than fix the Makefile
	emake -f /dev/null LDLIBS="${LIBS}" ${PN}
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r komidata/.

	doman ${PN}.6
	dodoc CHANGELOG.txt README.txt

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
