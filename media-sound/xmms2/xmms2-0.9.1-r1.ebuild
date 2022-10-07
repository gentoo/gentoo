# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit multiprocessing optfeature perl-functions python-single-r1 toolchain-funcs

DESCRIPTION="X(cross)platform Music Multiplexing System, next generation of the XMMS player"
HOMEPAGE="https://github.com/XMMS2"
SRC_URI="https://github.com/xmms2/xmms2-devel/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ~riscv x86"

# IUSE static map to be passed to --with-{optionals,plugins}=opt1,opt2,...
# flag:opt = `usev flag opt`, opt = `usev opt`, :opt = `echo opt`
# (if have a use for some of these disabled features, please fill a bug)
XMMS2_OPTIONALS=(
	cxx:xmmsclient++,xmmsclient++-glib :launcher mlib-update:medialib-updater
	:nycli perl :pixmaps python server:s4 test:tests
	# disabled: et,mdns,migrate-collections,ruby,sqlite2s4,vistest,xmmsclient-cf,xmmsclient-ecore
)
XMMS2_PLUGINS=(
	aac:faad airplay alsa ao :asx cdda :cue curl :diskwrite :equalizer
	ffmpeg:apefile,asf,avcodec,flv,tta :file flac fluidsynth:fluidsynth,mid1,midsquash
	gme :html ices :icymetaint :id3v2 jack :karaoke :m3u mac +mad mms modplug
	mp3:mpg123 :mp4 musepack :normalize :null :nulstripper ofa opus oss :pls
	pulseaudio:pulse :replaygain samba sid sndfile speex tremor vocoder +vorbis
	:wave wavpack :xml xml:rss,xspf zeroconf:daap
	# disabled: coreaudio,gvfs,nms,sc68,sun,waveout
)

IUSE="
	${XMMS2_OPTIONALS[@]%:*}
	${XMMS2_PLUGINS[@]%:*}
	+server valgrind"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test ) !server? ( test )"

COMMON_DEPEND="
	dev-libs/glib:2
	sys-libs/readline:=
	server? (
		aac? ( media-libs/faad2 )
		airplay? ( dev-libs/openssl:= )
		alsa? ( media-libs/alsa-lib )
		ao? ( media-libs/libao )
		cdda? (
			dev-libs/libcdio-paranoia:=
			dev-libs/libcdio:=
			media-libs/libdiscid
		)
		curl? ( net-misc/curl )
		ffmpeg? ( media-video/ffmpeg:= )
		flac? ( media-libs/flac:= )
		fluidsynth? ( media-sound/fluidsynth:= )
		gme? ( media-libs/game-music-emu )
		ices? (
			media-libs/libogg
			media-libs/libshout
			media-libs/libvorbis
		)
		jack? ( virtual/jack )
		mac? ( media-sound/mac )
		mad? ( media-libs/libmad )
		mms? (
			media-libs/libmms
			media-video/ffmpeg:=
		)
		modplug? ( media-libs/libmodplug )
		mp3? ( media-sound/mpg123 )
		musepack? ( media-sound/musepack-tools )
		ofa? (
			dev-libs/expat
			media-libs/libofa
			sci-libs/fftw:3.0=
		)
		opus? (
			media-libs/libogg
			media-libs/opus
			media-libs/opusfile
		)
		pulseaudio? ( media-libs/libpulse )
		samba? ( net-fs/samba )
		sid? ( media-libs/libsidplay:2 )
		sndfile? ( media-libs/libsndfile )
		speex? (
			media-libs/libogg
			media-libs/speex
		)
		tremor? ( media-libs/tremor )
		vocoder? (
			media-libs/libsamplerate
			sci-libs/fftw:3.0=
		)
		vorbis? ( media-libs/libvorbis )
		wavpack? ( media-sound/wavpack )
		xml? ( dev-libs/libxml2 )
		zeroconf? (
			net-dns/avahi[mdnsresponder-compat]
			net-misc/curl
		)
	)"
RDEPEND="
	${COMMON_DEPEND}
	perl? (
		dev-lang/perl
		dev-perl/glib-perl
		virtual/perl-Carp
		virtual/perl-IO
		virtual/perl-Scalar-List-Utils
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
	)"
DEPEND="
	${COMMON_DEPEND}
	cxx? ( dev-libs/boost )
	test? ( dev-util/cunit )"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	perl? (	dev-perl/Pod-Parser )
	python? ( $(python_gen_cond_dep 'dev-python/cython[${PYTHON_USEDEP}]') )
	test? ( valgrind? ( dev-util/valgrind ) )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.1-cpp-client.patch
	"${FILESDIR}"/${PN}-0.9.1-faad.patch
	"${FILESDIR}"/${PN}-0.9.1-rtvg.patch
)

src_prepare() {
	default

	# meant to be configured, but give a default for out-of-the-box midi
	sed -e "s|/path/to/.*sf2|${EPREFIX}/usr/share/sounds/sf2/FluidR3_GM.sf2|" \
		-i src/plugins/fluidsynth/fluidsynth.c || die
}

src_configure() {
	local waf=(
		./waf configure
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--boost-includes="${ESYSROOT}"/usr/include # needed for prefix
		--with-target-platform="${CHOST}"
	)

	xmms2_flag() {
		local IFS=:
		set -- ${1#+}

		if [[ ${1} ]]; then
			usev ${1} ,${2:-${1}}
		else
			echo ,${2}
		fi
	}

	local flag optionals plugins

	if use server; then
		for flag in "${XMMS2_PLUGINS[@]}"; do
			plugins+=$(xmms2_flag ${flag})
		done
	else
		waf+=( --without-xmms2d )
	fi

	for flag in "${XMMS2_OPTIONALS[@]}"; do
		optionals+=$(xmms2_flag ${flag})
	done

	waf+=(
		# pass even if empty to avoid automagic
		--with-optionals=${optionals:1}
		--with-plugins=${plugins:1}
	)

	if use perl; then
		perl_set_version
		waf+=( --with-perl-archdir="${ARCH_LIB}" )
	fi

	if use valgrind; then
		if valgrind true &>/dev/null; then
			waf+=( --with-valgrind )
		else
			ewarn "valgrind was disabled due to failing a basic sanity check" #807271
		fi
	fi

	tc-export AR CC CXX

	echo "${waf[*]}"
	"${waf[@]}" || die
}

src_compile() {
	./waf build -j$(makeopts_jobs) --verbose --notests || die
}

src_test() {
	./waf --alltests || die
}

src_install() {
	./waf install --destdir="${D}" --without-ldconfig --notests || die

	dodoc AUTHORS README.mdown *.ChangeLog

	use python && python_optimize

	# to avoid editing waftools/man.py (use find given not always installed)
	find "${ED}" -name '*.gz' -exec gzip -d {} + || die
}

pkg_postinst() {
	use fluidsynth && optfeature "the default MIDI soundfont" media-sound/fluid-soundfont
}
