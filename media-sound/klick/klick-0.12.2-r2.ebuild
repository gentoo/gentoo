# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )

inherit python-any-r1 scons-utils toolchain-funcs

DESCRIPTION="An advanced command-line based metronome for JACK"
HOMEPAGE="http://das.nasophon.de/klick"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug osc rubberband"

RDEPEND="media-libs/libsamplerate
	media-libs/libsndfile
	virtual/jack
	osc? ( media-libs/liblo )
	rubberband? ( media-libs/rubberband )"
DEPEND="${RDEPEND}
	dev-libs/boost"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-sconstruct.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

HTML_DOCS=( doc/manual.html )

src_configure() {
	MYSCONS=(
		CXX="$(tc-getCXX)"
		CXXFLAGS="${CXXFLAGS}"
		LINKFLAGS="${LDFLAGS}"
		PREFIX="${EPREFIX}/usr"
		DESTDIR="${D}"
		DEBUG=$(usex debug)
		OSC=$(usex osc)
		RUBBERBAND=$(usex rubberband)
	)
}

src_compile() {
	escons "${MYSCONS[@]}"
}

src_install() {
	escons "${MYSCONS[@]}" install
	einstalldocs
}
