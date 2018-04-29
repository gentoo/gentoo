# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop flag-o-matic

DESCRIPTION="A Sega Genesis/CD/32X emulator"
HOMEPAGE="https://sourceforge.net/projects/gens/"
SRC_URI="mirror://sourceforge/gens/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/opengl
	>=media-libs/libsdl-1.2[joystick,video]
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-0.98
"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/${P}-romsdir.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-ovflfix.patch \
		"${FILESDIR}"/${P}-gcc34.patch
	sed -i -e '1i#define OF(x) x' src/gens/util/file/unzip.h || die
	append-ldflags -Wl,-z,noexecstack
}

src_configure() {
	use amd64 && multilib_toolchain_setup x86 #441876
	econf \
		--disable-gtktest \
		--disable-sdltest
}

src_install() {
	DOCS="AUTHORS BUGS README gens.txt history.txt" \
		default
	newicon pixmaps/gens_small.png ${PN}.png
	make_desktop_entry "${PN}" "Gens"
}
