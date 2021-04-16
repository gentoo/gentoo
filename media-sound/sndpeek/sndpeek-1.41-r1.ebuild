# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="real-time audio visualization"
HOMEPAGE="http://soundlab.cs.princeton.edu/software/sndpeek/"
SRC_URI="http://soundlab.cs.princeton.edu/software/${PN}/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa jack oss"

RDEPEND="
	app-eselect/eselect-sndpeek
	media-libs/freeglut
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	media-libs/libsndfile
	jack? ( virtual/jack )
	alsa? ( media-libs/alsa-lib )
"
DEPEND="${RDEPEND}"
REQUIRED_USE="|| ( alsa jack oss )"

DOCS=( AUTHORS README THANKS TODO VERSIONS )

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
#	"${FILESDIR}/${PN}-1.4-gcc.patch"
)

compile_backend() {
	backend=$1
	cd "${S}/src/sndpeek"
	einfo "Compiling against ${backend}"
	emake -f "makefile.${backend}" CC=$(tc-getCC) \
		CXX=$(tc-getCXX)
	mv sndpeek{,-${backend}}
	emake -f "makefile.${backend}" clean
	cd -
}

src_compile() {
	use alsa && compile_backend alsa
	use jack && compile_backend jack
	use oss && compile_backend oss
}

src_install() {
	use alsa && dobin src/sndpeek/sndpeek-alsa
	use jack && dobin src/sndpeek/sndpeek-jack
	use oss && dobin src/sndpeek/sndpeek-oss
	einstalldocs
}

pkg_postinst() {
	elog "Sndpeek now can use many audio engines, so you can specify audio engine"
	elog "with sndpeek-{jack,alsa,oss}"
	elog "Or you can use 'eselect sndpeek' to set the audio engine"

	einfo "Calling eselect sndpeek update..."
	eselect sndpeek update --if-unset
}
