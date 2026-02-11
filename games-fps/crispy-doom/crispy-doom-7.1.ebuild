# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit autotools prefix python-any-r1 xdg

DESCRIPTION="A limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
HOMEPAGE="https://github.com/fabiangreffrath/crispy-doom/"
SRC_URI="https://github.com/fabiangreffrath/crispy-doom/archive/${P}.tar.gz"
S=${WORKDIR}/${PN}-${P}

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fluidsynth libsamplerate +midi png truecolor vorbis zlib"
REQUIRE_USE="fluidsynth? ( midi )"

DEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-mixer[fluidsynth?,midi?,vorbis?]
	media-libs/sdl2-net
	libsamplerate? ( media-libs/libsamplerate )
	png? ( media-libs/libpng:= )
	zlib? ( virtual/zlib:= )
"
RDEPEND="${DEPEND}"
# ${PYTHON_DEPS} for bash-completion and docs (manpages)
BDEPEND="${PYTHON_DEPS}"

src_prepare() {
	default
	hprefixify src/d_iwad.c
	eautoreconf
}

src_configure() {
	local myconf=(
		--enable-bash-completion
		--enable-doc
		--disable-fonts
		--disable-icons
		$(use_with libsamplerate)
		$(use_with png libpng)
		--enable-sdl2mixer
		--enable-sdl2net
		$(use_with fluidsynth)
		$(use_enable truecolor)
		$(use_with zlib)
		--disable-zpool
	)

	econf "${myconf[@]}"
}

src_install() {
	local DOCS=()
	default
	mv "${ED}"/usr/share/doc/crispy-{doom,heretic,hexen,strife}/* \
		"${ED}"/usr/share/doc/${PF}/ || die
	rmdir "${ED}"/usr/share/doc/crispy-{doom,heretic,hexen,strife} || die
}
