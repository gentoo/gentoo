# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Snd is a sound editor"
HOMEPAGE="http://ccrma.stanford.edu/software/snd/"
SRC_URI="ftp://ccrma-ftp.stanford.edu/pub/Lisp/${P}.tar.gz"

LICENSE="Snd BSD-2 HPND GPL-2+ LGPL-2.1+ LGPL-3+ ruby? ( free-noncomm ) s7? ( free-noncomm )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="alsa doc fftw gmp gsl gtk jack ladspa motif opengl oss portaudio pulseaudio readline ruby +s7"

RDEPEND="media-libs/audiofile
	alsa? ( media-libs/alsa-lib )
	fftw? ( sci-libs/fftw:3.0= )
	gmp? (
		dev-libs/gmp:0=
		dev-libs/mpc
		dev-libs/mpfr:0=
	)
	gsl? ( sci-libs/gsl:= )
	gtk? (
		x11-libs/gtk+:3
		x11-libs/pango
		x11-libs/cairo
		opengl? ( x11-libs/gtkglext )
	)
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/ladspa-sdk )
	motif? ( >=x11-libs/motif-2.3:0 )
	opengl? ( virtual/opengl )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	readline? ( sys-libs/readline:* )
	ruby? ( dev-lang/ruby:* )"
DEPEND="${RDEPEND}"

REQUIRED_USE="
	?? ( portaudio pulseaudio )
	?? ( ruby s7 )"

PATCHES=(
	"${FILESDIR}/${PN}-17.4-portaudio.patch"
)

pkg_setup() {
	if ! use gtk && ! use motif ; then
		ewarn "Warning: no graphic toolkit selected (gtk or motif)."
		ewarn "Upstream suggests to enable one of the toolkits (or both)"
		ewarn "or only the command line utilities will be helpful."
	fi
}

src_prepare() {
	default
	sed -i -e "s:-O2 ::" configure.ac || die
	eautoreconf
}

src_configure() {
	# Workaround executable sections QA warning (bug #348754)
	append-ldflags -Wl,-z,noexecstack

	local myconf
	if ! use ruby && ! use s7 ; then
		myconf+=" --without-extension-language"
	fi

	econf \
		$(use_with alsa) \
		$(use_with fftw) \
		$(use_with gmp) \
		$(use_with gsl) \
		$(use_with gtk) \
		$(use_with jack) \
		$(use_with ladspa) \
		$(use_with motif) \
		$(use_with oss) \
		$(use_with portaudio) \
		$(use_with pulseaudio) \
		$(use_with ruby) \
		$(use_with s7) \
		${myconf}
}

src_compile() {
	emake snd

	# Do not compile ruby extensions for command line programs since they fail
	sed -i -e "s:HAVE_RUBY 1:HAVE_RUBY 0:" mus-config.h || die

	local i
	for i in sndplay sndinfo; do
	   emake ${i}
	done
}

src_install () {
	dobin snd sndplay sndinfo

	if use ruby ; then
		insinto /usr/share/snd
		doins *.rb
	fi

	if use s7 ; then
		insinto /usr/share/snd
		doins *.scm
	fi

	use doc && HTML_DOCS=( *.html pix/*.png )
	einstalldocs
	dodoc HISTORY.Snd
}
