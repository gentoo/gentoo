# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic autotools games

DESCRIPTION="gameboy, gameboy color, and gameboy advance emulator"
HOMEPAGE="http://vba.ngemu.com/"
SRC_URI="mirror://sourceforge/vba/VisualBoyAdvance-src-${PV}.tar.gz
	mirror://gentoo/${P}-deprecatedsigc++.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="gtk cpu_flags_x86_mmx nls"

RDEPEND="media-libs/libpng:0
	media-libs/libsdl[joystick,sound,video]
	sys-libs/zlib[minizip]
	gtk? (
		>=x11-libs/gtk+-2.4:2
		>=dev-cpp/gtkmm-2.4:2.4
		>=dev-cpp/libglademm-2.4:2.4
		>=dev-libs/libsigc++-2.6:2
	)
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	cpu_flags_x86_mmx? ( dev-lang/nasm )
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/VisualBoyAdvance-${PV}

src_prepare() {
	cat >> src/i386/2xSaImmx.asm <<-EOF
		%ifidn __OUTPUT_FORMAT__,elf
		section .note.GNU-stack noalloc noexec nowrite progbits
		%endif
	EOF

	epatch \
		"${FILESDIR}"/${PV}-homedir.patch \
		"${FILESDIR}"/${PV}-gcc34.patch \
		"${FILESDIR}"/${PV}-gcc41.patch \
		"${FILESDIR}"/${P}-gcc47.patch \
		"${WORKDIR}"/${P}-deprecatedsigc++.patch \
		"${FILESDIR}"/${P}-uninit.patch \
		"${FILESDIR}"/${P}-glibc2.10.patch \
		"${FILESDIR}"/${P}-ovflfix.patch \
		"${FILESDIR}"/${P}-libpng15.patch \
		"${FILESDIR}"/${P}-zlib.patch \
		"${FILESDIR}"/${P}-zlib-1.2.6.patch \
		"${FILESDIR}"/${P}-sys-types.patch \
		"${FILESDIR}"/${P}-libsigc26.patch

	mv configure.in configure.ac || die
	eautoreconf

	sed -i \
		-e 's:$(localedir):/usr/share/locale:' \
		-e 's:$(datadir)/locale:/usr/share/locale:' \
		$(find . -name 'Makefile.in*') || die
}

src_configure() {
	# -O3 causes GCC to behave badly and hog memory, bug #64670.
	replace-flags -O3 -O2

	append-cxxflags -std=c++11

	# Removed --enable-c-core as it *should* determine this based on arch
	egamesconf \
		$(use_with cpu_flags_x86_mmx mmx) \
		$(use_enable gtk gtk 2.4) \
		$(use_enable nls)
}

src_install() {
	default
	if use gtk ; then
		newicon src/gtk/images/vba-64.png ${PN}.png
		make_desktop_entry gvba VisualBoyAdvance
	fi
	prepgamesdirs
}
