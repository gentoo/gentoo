# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A Linux/SDL-Port of the famous DGen MegaDrive/Genesis-Emulator"
HOMEPAGE="http://dgen.sourceforge.net/"
SRC_URI="mirror://sourceforge/dgen/files/${P}.tar.gz"

LICENSE="dgen-sdl BSD BSD-2 free-noncomm LGPL-2.1+ GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="joystick opengl"

RDEPEND="
	media-libs/libsdl[joystick?,opengl?]
	app-arch/libarchive
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}"
BDEPEND="x86? ( dev-lang/nasm )"

PATCHES=(
	"${FILESDIR}"/${P}-joystick.patch
	"${FILESDIR}"/${P}-AM_PROG_AR.patch
	"${FILESDIR}"/${P}-clang-c++11.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable x86 asm) \
		$(use_enable joystick) \
		$(use_enable opengl)
}

src_compile() {
	emake -C musa m68kops.h
	emake
}

src_install() {
	default
	dodoc sample.dgenrc
}
