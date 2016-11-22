# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="real-time audio visualization"
HOMEPAGE="http://soundlab.cs.princeton.edu/software/sndpeek/"
SRC_URI="http://soundlab.cs.princeton.edu/software/${PN}/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa jack oss"

RDEPEND="media-libs/freeglut
	virtual/opengl
	virtual/glu
	x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXext
	media-libs/libsndfile
	jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( media-libs/alsa-lib )
	app-eselect/eselect-sndpeek"
DEPEND="${RDEPEND}"
REQUIRED_USE="|| ( alsa jack oss )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3-makefile.patch \
		"${FILESDIR}"/${P}-gcc.patch \
		"${FILESDIR}"/${P}-ldflags.patch
}

compile_backend() {
	backend=$1
	cd "${S}/src/sndpeek"
	einfo "Compiling against ${backend}"
	emake -f "makefile.${backend}" CC=$(tc-getCC) \
		CXX=$(tc-getCXX) || die "emake failed"
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
	dodoc AUTHORS README THANKS TODO VERSIONS
}

pkg_postinst() {
	elog "Sndpeek now can use many audio engines, so you can specify audio engine"
	elog "with sndpeek-{jack,alsa,oss}"
	elog "Or you can use 'eselect sndpeek' to set the audio engine"

	einfo "Calling eselect sndpeek update..."
	eselect sndpeek update --if-unset
}
