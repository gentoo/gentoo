# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Lode-Runner-like arcade game"
HOMEPAGE="https://www.linuxmotors.com/linux/scavenger/index.html"
SRC_URI="
	https://www.linuxmotors.com/linux/scavenger/downloads/${P}.tgz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/alsa-lib
	x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-misc-fixes.patch
)

src_compile() {
	tc-export CC
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	# skip using imake for simplicity
	local cppargs=(
		-DLIBNAME="'\"${EPREFIX}/usr/share/${PN}\"'"
		$($(tc-getPKG_CONFIG) --cflags alsa x11)
	)
	append-cppflags "${cppargs[@]}"

	LDLIBS="$($(tc-getPKG_CONFIG) --libs alsa x11)" \
		emake -C src -E "scav: anim.o edit.o x.o sound.o"
}

src_install() {
	newbin src/scav scavenger
	doman src/scavenger.6

	dodoc CREDITS DOC README TODO changelog

	insinto /usr/share/${PN}
	doins -r data/.

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry scavenger XScavenger
}
