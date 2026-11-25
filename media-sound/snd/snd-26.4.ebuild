# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic optfeature toolchain-funcs

DESCRIPTION="Sound editor"
HOMEPAGE="https://ccrma.stanford.edu/software/snd/"
SRC_URI="https://ccrma.stanford.edu/software/${PN}/${P}.tar.gz"

LICENSE="Snd 0BSD BSD-2 HPND GPL-2+ LGPL-2.1+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
# alsa may be optional too but at-most-one with pulseaudio breaks profiles
IUSE="fftw gmp gsl gui jack ladspa notcurses opengl oss portaudio pulseaudio ruby +s7"
REQUIRED_USE="
	?? ( jack oss pulseaudio portaudio )
	?? ( gui notcurses )
	?? ( ruby s7 )
	notcurses? ( s7 )
"

RDEPEND="
	media-libs/alsa-lib
	fftw? ( sci-libs/fftw:3.0= )
	gmp? (
		dev-libs/gmp:=
		dev-libs/mpc:=
		dev-libs/mpfr:=
	)
	gsl? ( sci-libs/gsl:= )
	gui? (
		x11-libs/motif:0=
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXft
		x11-libs/libXpm
		x11-libs/libXt
		opengl? (
			media-libs/glu
			media-libs/libglvnd[X]
		)
	)
	jack? (
		media-libs/libsamplerate
		virtual/jack
	)
	ladspa? ( media-libs/ladspa-sdk )
	notcurses? ( dev-cpp/notcurses )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	ruby? ( dev-lang/ruby:* )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# upstream searches <=ruby-3.0, try forcing with latest ruby version
	if use ruby; then
		local ruby_ver="$(best_version dev-lang/ruby | sed 's/.*\(ruby-[0-9]\+\.[0-9]\+\).*/\1/')"
		sed -e "s/m4_foreach(\[ruby_version\].*/m4_foreach([ruby_version], [[${ruby_ver}]],/" \
			-i configure.ac || die
	fi

	sed -i -e "s:-O2 ::" configure.ac || die
	eautoreconf
}

src_configure() {
	# -Wincompatible-pointer-types
	use ruby && append-cflags -std=gnu17

	# fix s7 bindings exporting s7_f symbols
	use s7 && append-ldflags -Wl,--export-dynamic

	export ac_cv_path_PKG_CONFIG="$(tc-getPKG_CONFIG)"

	# define the path for all tools instead of automagic
	local tools=(
		oggdec
		oggenc
		mpg123
		flac
		speexdec
		speexenc
		timidity
		wavpack
		wvunpack
	)
	local tool
	for tool in "${tools[@]}"; do
		export ac_cv_path_PATH_${tool^^}="${EPREFIX}/usr/bin/${tool}"
	done

	local myeconfargs=(
		$(use_with fftw)
		$(use_with gmp)
		$(use_with gsl)
		$(use_with gui)
		$(use_with jack)
		$(use_with ladspa)
		$(use_with notcurses)
		$(use_with oss)
		$(use_with portaudio)
		$(use_with pulseaudio)
		$(use_with ruby)
		$(use_with s7)
	)

	if use gui && use opengl; then
		# -Werror=lto-type-mismatch
		filter-lto
		myeconfargs+=( --with-gl )
	else
		myeconfargs+=( --without-gl )
	fi

	# determine audio backend and use alsa as a fallback
	if use oss || use portaudio || use pulseaudio; then
		myeconfargs+=( --without-alsa )
	else
		# jack and alsa can be used together
		myeconfargs+=( --with-alsa )
	fi

	if ! use ruby && ! use s7 ; then
		myeconfargs+=( --without-extension-language )
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake snd

	# Do not compile ruby extensions for command line programs since they fail
	if use ruby; then
		sed -i -e "s:HAVE_RUBY 1:HAVE_RUBY 0:" mus-config.h || die
	fi

	emake sndplay sndinfo
}

src_install() {
	dobin snd sndplay sndinfo

	if use gui; then
		newicon pix/s.png ${PN}.png
		make_desktop_entry --eapi9 ${PN} -C "sound editor" -c "AudioVideo;AudioVideoEditing"
	fi

	if use ruby ; then
		insinto /usr/share/snd
		doins *.rb
	fi

	if use s7 ; then
		insinto /usr/share/snd
		doins *.scm s7.h
	fi

	doman snd.1

	local DOCS=( *.Snd NEWS )
	local HTML_DOCS=( *.html pix/*.png )
	einstalldocs
}

pkg_postinst() {
	optfeature_header "converting in audio formats:"
	optfeature flac media-libs/flac
	optfeature MIDI media-sound/timidity++
	optfeature MPEG media-sound/mpg123-base
	optfeature Ogg media-sound/vorbis-tools
	optfeature Speex media-libs/speex[utils]
	optfeature WavPack media-sound/wavpack
}
