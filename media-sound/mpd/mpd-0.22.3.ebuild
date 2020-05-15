# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic linux-info meson systemd xdg-utils

DESCRIPTION="The Music Player Daemon (mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/MPD"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 x86"
IUSE="+alsa ao +audiofile bzip2 cdio chromaprint +cue +curl doc +dbus
	+eventfd expat faad +ffmpeg +fifo flac fluidsynth gme +icu +id3tag +inotify
	+ipv6 jack lame libmpdclient libsamplerate libsoxr +mad mikmod mms
	modplug mpg123 musepack +network nfs openal opus oss pipe pulseaudio qobuz
	recorder samba selinux sid signalfd sndfile sndio soundcloud sqlite systemd
	test tidal twolame udisks unicode vorbis wavpack webdav wildmidi upnp
	zeroconf zip zlib"

OUTPUT_PLUGINS="alsa ao fifo jack network openal oss pipe pulseaudio sndio recorder"
DECODER_PLUGINS="audiofile faad ffmpeg flac fluidsynth mad mikmod
	modplug mpg123 musepack flac sid vorbis wavpack wildmidi"
ENCODER_PLUGINS="audiofile flac lame twolame vorbis"

REQUIRED_USE="
	|| ( ${OUTPUT_PLUGINS} )
	|| ( ${DECODER_PLUGINS} )
	network? ( || ( ${ENCODER_PLUGINS} ) )
	recorder? ( || ( ${ENCODER_PLUGINS} ) )
	upnp? ( expat )
	webdav? ( curl expat )
	"

RESTRICT="!test? ( test )"

RDEPEND="
	acct-user/mpd
	sys-libs/liburing:=
	alsa? (
		media-libs/alsa-lib
		media-sound/alsa-utils
	)

	ao? ( media-libs/libao[alsa?,pulseaudio?] )
	audiofile? ( media-libs/audiofile:= )

	cdio? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia
	)

	chromaprint? ( media-libs/chromaprint )
	curl? ( net-misc/curl )
	dbus? ( sys-apps/dbus )
	doc? ( dev-python/sphinx )
	expat? ( dev-libs/expat )
	faad? ( media-libs/faad2 )
	ffmpeg? ( media-video/ffmpeg:0= )
	flac? ( media-libs/flac )
	fluidsynth? ( media-sound/fluidsynth )
	gme? ( >=media-libs/game-music-emu-0.6.0_pre20120802 )
	icu? (  dev-libs/icu:= )
	id3tag? ( media-libs/libid3tag )
	jack? ( virtual/jack )
	lame? ( network? ( media-sound/lame ) )
	libmpdclient? ( media-libs/libmpdclient )
	libsamplerate? ( media-libs/libsamplerate )
	libsoxr? ( media-libs/soxr )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod )
	mms? ( media-libs/libmms )
	modplug? ( media-libs/libmodplug )
	mpg123? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	network? ( media-libs/libshout )
	nfs? ( net-fs/libnfs )
	openal? ( media-libs/openal )
	opus? ( media-libs/opus )
	pulseaudio? ( media-sound/pulseaudio )
	qobuz? ( dev-libs/libgcrypt:0 )
	samba? ( net-fs/samba )
	selinux? ( sec-policy/selinux-mpd )
	sid? ( || (
		media-libs/libsidplay:2
		media-libs/libsidplayfp
	) )
	sndfile? ( media-libs/libsndfile )
	sndio? ( media-sound/sndio )
	soundcloud? ( >=dev-libs/yajl-2:= )
	sqlite? ( dev-db/sqlite:3 )
	systemd? ( sys-apps/systemd )
	tidal? ( dev-libs/yajl
		net-misc/curl )
	twolame? ( media-sound/twolame )
	udisks? ( sys-fs/udisks:2 )
	upnp? ( net-libs/libupnp:0 )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	wildmidi? ( media-sound/wildmidi )
	zeroconf? ( net-dns/avahi[dbus] )
	zip? ( dev-libs/zziplib )
	zlib? ( sys-libs/zlib:= )"

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.58:=
	test? ( dev-cpp/gtest )"

BDEPEND=">=dev-util/meson-0.49.2
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.18.conf.patch
)

pkg_setup() {
	if use eventfd; then
		CONFIG_CHECK+=" ~EVENTFD"
		ERROR_EVENTFD="${P} requires eventfd in-kernel support."
	fi

	if use signalfd; then
		CONFIG_CHECK+=" ~SIGNALFD"
		ERROR_SIGNALFD="${P} requires signalfd in-kernel support."
	fi

	if use inotify; then
		CONFIG_CHECK+=" ~INOTIFY_USER"
		ERROR_INOTIFY_USER="${P} requires inotify in-kernel support."
	fi

	if use eventfd || use signalfd || use inotify; then
		linux-info_pkg_setup
	fi

	elog "If you will be starting mpd via /etc/init.d/mpd, please make
	sure that MPD's pid_file is _set_."
}

src_prepare() {
	cp -f doc/mpdconf.example doc/mpdconf.dist || die "cp failed"
	default
}

src_configure() {
	local emesonargs=(
		-Dbzip2=$(usex bzip2 enabled disabled)
		-Dcdio_paranoia=$(usex cdio enabled disabled)
		-Dchromaprint=$(usex chromaprint enabled disabled)
		-Dcue=$(usex cue true false)
		-Dcurl=$(usex curl enabled disabled)
		-Ddbus=$(usex dbus enabled disabled)
		-Deventfd=$(usex eventfd true false)
		-Dexpat=$(usex expat enabled disabled)
		-Dicu=$(usex icu enabled disabled)
		-Did3tag=$(usex id3tag enabled disabled)
		-Dinotify=$(usex inotify true false)
		-Dipv6=$(usex ipv6 enabled disabled)
		-Diso9660=$(usex cdio enabled disabled)
		-Dlibmpdclient=$(usex libmpdclient enabled disabled)
		-Dlibsamplerate=$(usex libsamplerate enabled disabled)
		-Dmms=$(usex mms enabled disabled)
		-Dnfs=$(usex nfs enabled disabled)
		-Dsignalfd=$(usex signalfd true false)
		-Dsmbclient=$(usex samba enabled disabled)
		-Dsoxr=$(usex libsoxr enabled disabled)
		-Dsqlite=$(usex sqlite enabled disabled)
		-Dsystemd=$(usex systemd enabled disabled)
		-Dtest=$(usex test true false)
		-Dudisks=$(usex udisks enabled disabled)
		-Dupnp=$(usex upnp enabled disabled)
		-Dwebdav=$(usex webdav enabled disabled)
		-Dzeroconf=$(usex zeroconf avahi disabled)
		-Dzlib=$(usex zlib enabled disabled)
		-Dzzip=$(usex zip enabled disabled)
		)

	emesonargs+=(
		-Dalsa=$(usex alsa enabled disabled)
		-Dao=$(usex ao enabled disabled)
		-Dfifo=$(usex fifo true false)
		-Djack=$(usex jack enabled disabled)
		-Dopenal=$(usex openal enabled disabled)
		-Doss=$(usex oss enabled disabled)
		-Dpipe=$(usex pipe true false)
		-Dpulse=$(usex pulseaudio enabled disabled)
		-Drecorder=$(usex recorder true false)
		-Dsndio=$(usex sndio enabled disabled)
	)

	if use samba || use upnp; then
		emesonargs+=( -Dneighbor=true )
	fi

	append-lfs-flags
	append-ldflags "-L/usr/$(get_libdir)/sidplay/builders"

	if use network; then

	emesonargs+=(
		-Dshine=disabled
		-Dshout=enabled
		-Dvorbisenc=$(usex vorbis enabled disabled)
		-Dhttpd=true
		-Dlame=$(usex lame enabled disabled)
		-Dtwolame=$(usex twolame enabled disabled)
		-Dwave_encoder=$(usex audiofile true false)
	)
	fi

	emesonargs+=(
		# media-libs/adplug is not packaged anymore
		-Dadplug=disabled
		-Daudiofile=$(usex audiofile enabled disabled)
		-Dfaad=$(usex faad enabled disabled)
		-Dffmpeg=$(usex ffmpeg enabled disabled)
		-Dflac=$(usex flac enabled disabled)
		-Dfluidsynth=$(usex fluidsynth enabled disabled)
		-Dgme=$(usex gme enabled disabled)
		-Dmad=$(usex mad enabled disabled)
		-Dmikmod=$(usex mikmod enabled disabled)
		-Dmodplug=$(usex modplug enabled disabled)
		-Dmpcdec=$(usex musepack enabled disabled)
		-Dmpg123=$(usex mpg123 enabled disabled)
		-Dopus=$(usex opus enabled disabled)
		-Dsidplay=$(usex sid enabled disabled)
		-Dsndfile=$(usex sndfile enabled disabled)
		-Dvorbis=$(usex vorbis enabled disabled)
		-Dwavpack=$(usex wavpack enabled disabled)
		-Dwildmidi=$(usex wildmidi enabled disabled)

	)

	emesonargs+=(
		-Dqobuz=$(usex qobuz enabled disabled)
		-Dsoundcloud=$(usex soundcloud enabled disabled)
		-Dtidal=$(usex tidal enabled disabled)
	)

	emesonargs+=(
		--libdir="/usr/$(get_libdir)"
		-Ddocumentation=$(usex doc enabled disabled)
		-Dsolaris_output=disabled

		-Ddatabase=true
		-Ddsd=true
		-Dio_uring=enabled
		-Dtcp=true

		-Dsystemd_system_unit_dir="$(systemd_get_systemunitdir)"
		-Dsystemd_user_unit_dir="$(systemd_get_userunitdir)"
		)

	if use icu; then
		emesonargs+=( -Diconv=enabled )
	else
		emesonargs+=( -Diconv=disabled )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /etc
	newins doc/mpdconf.dist mpd.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}-0.21.1.logrotate ${PN}

	newinitd "${FILESDIR}"/${PN}-0.21.4.init ${PN}

	if use unicode; then
		sed -i -e 's:^#filesystem_charset.*$:filesystem_charset "UTF-8":' \
			"${ED}"/etc/mpd.conf || die "sed failed"
	fi

	keepdir /var/lib/mpd
	keepdir /var/lib/mpd/music
	keepdir /var/lib/mpd/playlists

	rm -r "${ED}"/usr/share/doc/mpd || die

}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
