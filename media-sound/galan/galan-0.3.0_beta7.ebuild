# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="gAlan - Graphical Audio Language"
HOMEPAGE="http://galan.sourceforge.net/"
SRC_URI="mirror://sourceforge/galan/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa jack opengl vorbis"

RDEPEND="
	media-libs/liblrdf:=
	media-libs/ladspa-sdk
	media-libs/audiofile:=
	media-libs/libsndfile:=
	sci-libs/fftw:2.1=
	x11-libs/gtk+:2
	alsa? ( media-libs/alsa-lib:= )
	jack? ( virtual/jack )
	opengl? (
		x11-libs/gtkglarea:2=
		virtual/glu
	)
	vorbis? ( media-sound/vorbis-tools )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	rm README.w32 || die
}

src_configure() {
	# Use lrdf.pc to get -I/usr/include/raptor2 (lrdf.h -> raptor.h)
	append-cppflags $($(tc-getPKG_CONFIG) --cflags lrdf)
	econf --disable-static
}

src_install() {
	default
	dodoc NOTES

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
