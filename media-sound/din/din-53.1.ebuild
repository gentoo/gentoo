# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edos2unix xdg

DESCRIPTION="a software musical instrument and audio synthesizer"
HOMEPAGE="https://dinisnoise.org/"
SRC_URI="https://archive.org/download/dinisnoise_source_code/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+alsa jack"

RDEPEND="
	dev-lang/tcl:0=
	media-libs/libsdl:=
	virtual/glu
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
"

REQUIRED_USE="|| ( alsa jack )"

PATCHES=(
	"${FILESDIR}/${PN}-52-makefile.patch"
	"${FILESDIR}/${PN}-48-fix-random-constants.patch"
)

src_prepare() {
	default

	edos2unix pixmaps/${PN}.desktop

	use jack && (sed -i "s/-lasound/-ljack/g" src/Makefile.am || die "Failed to fix jack linking")

	eautoreconf
}

src_configure() {
	# Jack takes over alsa.
	local sound_engine

	use jack && sound_engine="UNIX_JACK" || sound_engine="LINUX_ALSA"

	econf CXXFLAGS="${CXXFLAGS} -D__${sound_engine}__"
}
