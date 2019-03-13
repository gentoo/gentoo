# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop qmake-utils xdg-utils

DESCRIPTION="Music audio files viewer and analiser"
HOMEPAGE="https://www.sonicvisualiser.org/"
SRC_URI="https://code.soundsoftware.ac.uk/attachments/download/2391/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="id3tag jack mad ogg osc +portaudio pulseaudio"

RDEPEND="
	app-arch/bzip2
	>=dev-libs/capnproto-0.6:=
	dev-libs/serd
	dev-libs/sord
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/alsa-lib
	media-libs/dssi
	media-libs/ladspa-sdk
	media-libs/liblrdf
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/rubberband
	media-libs/speex
	media-libs/vamp-plugin-sdk
	sci-libs/fftw:3.0=
	id3tag? ( media-libs/libid3tag )
	jack? ( media-sound/jack-audio-connection-kit )
	mad? ( media-libs/libmad )
	ogg? (
		media-libs/libfishsound
		>=media-libs/liboggz-1.1.0
	)
	osc? ( media-libs/liblo )
	portaudio? ( >=media-libs/portaudio-19_pre20071207 )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
	virtual/pkgconfig
	sys-devel/autoconf-archive
"

REQUIRED_USE="|| ( jack pulseaudio portaudio )"

PATCHES=(
	"${FILESDIR}/notest.patch"
	"${FILESDIR}/${P}-qt-5.11.patch"
)

sv_disable_opt() {
	einfo "Disabling $1"
	for i in . svapp svcore svgui ; do
		sed -i -e "/$1/d" "${S}/$i/configure.ac" || die "failed to remove $1 support"
	done
}

src_prepare() {
	default

	use id3tag || sv_disable_opt id3tag
	use jack || sv_disable_opt jack
	use mad || sv_disable_opt mad
	use ogg || sv_disable_opt fishsound
	use ogg || sv_disable_opt oggz
	use osc || sv_disable_opt liblo
	use portaudio || sv_disable_opt portaudio
	use pulseaudio || sv_disable_opt libpulse

	# capnproto 0.7 requires c++14 now
	sed -e 's/AX_CXX_COMPILE_STDCXX_11/AX_CXX_COMPILE_STDCXX_14/g' \
		-i configure.ac \
		-i */configure.ac \
		|| die

	eautoreconf

	# Those need to be regenerated as they must match current capnproto version
	einfo "Regenerating piper capnproto files"
	rm -f piper-cpp/vamp-capnp/piper.capnp.* || die
	mkdir -p piper/capnp || die
	cp "${FILESDIR}/piper.capnp" piper/capnp/ || die
	cd piper-cpp || die
	emake vamp-capnp/piper.capnp.h
}

src_configure() {
	export QMAKE="$(qt5_get_bindir)"/qmake
	econf
	eqmake5 -r sonic-visualiser.pro
	sed -e 's/std=gnu++11/std=gnu++14/g' \
		-i Makefile.* \
		-i checker/Makefile.* \
		|| die
}

src_test() {
	for i in test-svcore-base test-svcore-data-fileio test-svcore-data-model ; do
		einfo "Running ${i}"
		./${i} || die
	done
}

src_install() {
	dobin ${PN} piper-vamp-simple-server piper-convert vamp-plugin-load-checker
	dodoc README*
	#install samples
	insinto /usr/share/${PN}/samples
	doins samples/*
	# desktop entry
	doicon icons/sv-icon.svg
	domenu *.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
