# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="a software musical instrument and audio synthesizer"
HOMEPAGE="http://dinisnoise.org/"
SRC_URI="https://archive.org/download/dinisnoise_source_code/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa jack"

BDEPEND="
	app-text/dos2unix
	virtual/pkgconfig
"
CDEPEND="dev-lang/tcl:0=
	media-libs/libsdl:=
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
"
RDEPEND="${CDEPEND}"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
REQUIRED_USE="|| ( alsa jack )"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${P}-fix-random-constants.patch"
)

src_prepare() {
	default

	dos2unix pixmaps/${PN}.desktop || die "Failed to fix desktop file"

	use jack && (sed -i "s/-lasound/-ljack/g" src/Makefile.am || die "Failed to fix jack linking")

	eautoreconf
}

src_configure() {
	# Jack takes over alsa.
	local sound_engine

	use jack && sound_engine="UNIX_JACK" || sound_engine="LINUX_ALSA"

	econf CXXFLAGS="${CXXFLAGS} -D__${sound_engine}__"
}
