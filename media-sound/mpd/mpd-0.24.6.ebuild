# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info meson systemd xdg

DESCRIPTION="The Music Player Daemon (mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/MPD"
SRC_URI="https://www.musicpd.org/download/${PN}/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+alsa ao +audiofile bzip2 cdio chromaprint +curl doc +dbus
	+eventfd expat faad +ffmpeg flac fluidsynth gme httpd +icu +id3tag +inotify
	+io-uring jack lame libmpdclient libsamplerate libsoxr +mad mikmod mms
	modplug +mpg123 musepack nfs openal openmpt opus oss pipewire pulseaudio qobuz
	recorder samba selinux shout sid signalfd snapcast sndfile sndio sqlite
	systemd test tremor twolame upnp vorbis wavpack webdav wildmidi
	zeroconf zip zlib"

OUTPUT_PLUGINS="alsa ao jack httpd openal oss pipewire pulseaudio shout snapcast sndio recorder"
DECODER_PLUGINS="audiofile faad ffmpeg flac fluidsynth mad mikmod
	modplug mpg123 musepack opus openmpt flac sid tremor vorbis wavpack wildmidi"
ENCODER_PLUGINS="audiofile flac lame twolame vorbis"

REQUIRED_USE="
	|| ( ${OUTPUT_PLUGINS} )
	|| ( ${DECODER_PLUGINS} )
	?? ( tremor vorbis )
	httpd? ( || ( ${ENCODER_PLUGINS} ) )
	recorder? ( || ( ${ENCODER_PLUGINS} ) )
	shout? ( || ( ${ENCODER_PLUGINS} ) )
	qobuz? ( curl )
	upnp? ( curl expat )
	webdav? ( curl expat )
"

RESTRICT="!test? ( test )"

COMMON_ENCODERS="
	lame? ( media-sound/lame )
	twolame? ( media-sound/twolame )
"
RDEPEND="
	acct-user/mpd
	dev-libs/libfmt:=
	dev-libs/libpcre2:=
	alsa? (
		media-libs/alsa-lib
		media-sound/alsa-utils
	)
	ao? ( media-libs/libao[alsa?,pulseaudio?] )
	audiofile? ( media-libs/audiofile:= )
	bzip2? ( app-arch/bzip2 )
	cdio? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia:=
	)
	chromaprint? ( media-libs/chromaprint:= )
	curl? ( net-misc/curl )
	dbus? ( sys-apps/dbus )
	doc? (
		dev-python/sphinx
		dev-python/sphinx-rtd-theme
	)
	expat? ( dev-libs/expat )
	faad? ( media-libs/faad2 )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	fluidsynth? ( media-sound/fluidsynth:= )
	gme? ( media-libs/game-music-emu )
	httpd? ( ${COMMON_ENCODERS} )
	icu? (
		dev-libs/icu:=
		virtual/libiconv
	)
	id3tag? ( media-libs/libid3tag:= )
	io-uring? ( sys-libs/liburing:= )
	jack? ( virtual/jack )
	libmpdclient? ( media-libs/libmpdclient )
	libsamplerate? ( media-libs/libsamplerate )
	libsoxr? ( media-libs/soxr )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod )
	mms? ( media-libs/libmms )
	modplug? ( media-libs/libmodplug )
	mpg123? ( media-sound/mpg123-base )
	musepack? ( media-sound/musepack-tools )
	nfs? ( net-fs/libnfs:= )
	openal? ( media-libs/openal )
	openmpt? ( media-libs/libopenmpt )
	opus? (
		media-libs/libogg
		media-libs/opus
	)
	pulseaudio? ( media-libs/libpulse )
	pipewire? ( media-video/pipewire:= )
	qobuz? (
		!ffmpeg? ( dev-libs/libgcrypt:= )
		ffmpeg? ( media-video/ffmpeg )
	)
	recorder? ( ${COMMON_ENCODERS} )
	samba? ( net-fs/samba:= )
	selinux? ( sec-policy/selinux-mpd )
	shout? (
		${COMMON_ENCODERS}
		media-libs/libshout
	)
	sid? ( media-libs/libsidplayfp:= )
	sndfile? ( media-libs/libsndfile )
	sndio? ( media-sound/sndio:= )
	sqlite? ( dev-db/sqlite:3 )
	systemd? ( sys-apps/systemd:= )
	tremor? (
		media-libs/libogg
		media-libs/tremor
	)
	upnp? ( net-libs/libupnp:= )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	wavpack? ( media-sound/wavpack )
	wildmidi? ( media-sound/wildmidi )
	zeroconf? ( net-dns/avahi[dbus] )
	zip? ( dev-libs/zziplib:= )
	zlib? ( virtual/zlib:= )
"
DEPEND="
	${RDEPEND}
	qobuz? ( >=dev-cpp/nlohmann_json-3.11.3 )
	snapcast? ( >=dev-cpp/nlohmann_json-3.11.3 )
	test? ( dev-cpp/gtest )
"
BDEPEND="virtual/pkgconfig"

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

	if use io-uring; then
		CONFIG_CHECK+=" ~IO_URING"
		ERROR_IO_URING="${P} requires io-uring in-kernel support."
	fi

	if use eventfd || use signalfd || use inotify || use io-uring; then
		linux-info_pkg_setup
	fi
}

src_configure() {
	local emesonargs=(
		# media-libs/adplug is not packaged anymore
		-Dadplug=disabled
		$(meson_feature alsa)
		$(meson_feature ao)
		$(meson_feature audiofile)
		$(meson_feature bzip2)
		$(meson_feature cdio cdio_paranoia)
		$(meson_feature chromaprint)
		-Dcue=true
		$(meson_feature curl)
		$(meson_feature dbus)
		$(meson_use eventfd)
		$(meson_feature expat)
		$(meson_feature faad)
		$(meson_feature ffmpeg)
		-Dfifo=true
		$(meson_feature flac)
		$(meson_feature fluidsynth)
		$(meson_feature gme)
		$(meson_use httpd )
		$(meson_feature icu)
		$(meson_feature id3tag)
		$(meson_use inotify)
		-Dipv6=enabled
		$(meson_feature cdio iso9660)
		$(meson_feature io-uring io_uring)
		$(meson_feature jack)
		$(meson_feature libmpdclient)
		$(meson_feature libsamplerate)
		$(meson_feature mad)
		$(meson_feature mikmod)
		$(meson_feature mms)
		$(meson_feature modplug)
		$(meson_feature musepack mpcdec)
		$(meson_feature mpg123)
		$(meson_feature nfs)
		$(meson_feature openal)
		$(meson_feature openmpt)
		$(meson_feature opus)
		$(meson_feature oss)
		-Dpipe=true
		$(meson_feature pipewire)
		$(meson_feature pulseaudio pulse)
		$(meson_feature qobuz)
		$(meson_use recorder)
		$(meson_feature shout)
		$(meson_use signalfd)
		$(meson_feature samba smbclient)
		$(meson_use snapcast)
		$(meson_feature sid sidplay)
		$(meson_feature sndfile)
		$(meson_feature sndio)
		$(meson_feature libsoxr soxr)
		$(meson_feature sqlite)
		$(meson_feature systemd)
		$(meson_use test)
		$(meson_feature dbus udisks)
		-Dupnp=$(usex upnp pupnp disabled)
		$(meson_feature tremor)
		$(meson_feature vorbis)
		$(meson_feature wavpack)
		$(meson_feature wildmidi)
		$(meson_feature webdav)
		-Dzeroconf=$(usex zeroconf avahi disabled)
		$(meson_feature zlib)
		$(meson_feature zip zzip)

		--libdir="/usr/$(get_libdir)"
		$(meson_feature doc documentation)
		-Dsolaris_output=disabled

		-Ddatabase=true
		-Ddaemon=true
		-Ddsd=true
		-Dtcp=true

		-Dsystemd_system_unit_dir="$(systemd_get_systemunitdir)"
		-Dsystemd_user_unit_dir="$(systemd_get_userunitdir)"

		$(meson_feature icu iconv)
	)

	if use samba || use upnp; then
		emesonargs+=( -Dneighbor=true )
	fi

	append-lfs-flags

	# set useflag for encoders
	if use httpd || use shout || use recorder; then
		emesonargs+=(
			# not in tree
			-Dshine=disabled
			$(meson_feature lame)
			$(meson_feature twolame)
			$(meson_feature vorbis vorbisenc)
			$(meson_use audiofile wave_encoder)
		)
	else
		# avoid links even w/o encoder
		emesonargs+=(
			-Dlame=disabled
			-Dtwolame=disabled
		)
	fi

	# nlohmann_json is only required with these plugins enabled
	if use qobuz || use snapcast; then
		emesonargs+=(
			-Dnlohmann_json=enabled
		)
	fi

	meson_src_configure
}

src_install() {
	if use doc; then
		local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	else
		newman "${FILESDIR}"/${PN}.1-0.24.2 ${PN}.1
		newman "${FILESDIR}"/${PN}.conf.5-0.24.2 ${PN}.conf.5
	fi

	meson_src_install

	insinto /etc
	newins doc/mpdconf.example mpd.conf

	# When running MPD as system service, better switch to the user we provide
	sed -i \
		-e 's:^#user.*$:user "mpd":' \
		-e 's:^#group.*$:group "audio":' \
		"${ED}/etc/mpd.conf" || die

	if ! use systemd; then
		# Extra options for running MPD under OpenRC
		# (options that should not be set when using systemd)
		sed -i \
			-e '0,/^#log_file.*$/s::log_file "/var/log/mpd/mpd.log"\n&:' \
			-e '0,/^#pid_file.*$/s::pid_file "/run/mpd/mpd.pid"\n&:' \
			"${ED}/etc/mpd.conf" || die
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}-0.23.15.logrotate" "${PN}"

	newinitd "${FILESDIR}/${PN}-0.24.2.init" "${PN}"

	keepdir /var/lib/mpd
	keepdir /var/lib/mpd/music
	keepdir /var/lib/mpd/playlists
	keepdir /var/log/mpd

	rm -r "${ED}"/usr/share/doc/mpd || die

	fowners mpd:audio -R /var/lib/mpd
	fowners mpd:audio -R /var/log/mpd
}
