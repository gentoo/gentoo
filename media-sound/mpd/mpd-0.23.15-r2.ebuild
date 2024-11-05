# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info meson systemd xdg

DESCRIPTION="The Music Player Daemon (mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/MPD"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ppc ppc64 ~riscv ~x86"
IUSE="+alsa ao +audiofile bzip2 cdio chromaprint +cue +curl doc +dbus
	+eventfd expat faad +ffmpeg +fifo flac fluidsynth gme +icu +id3tag +inotify +io-uring
	jack lame libmpdclient libsamplerate libsoxr +mad mikmod mms
	modplug mpg123 musepack +network nfs openal openmpt opus oss pipe pipewire pulseaudio qobuz
	recorder samba selinux sid signalfd snapcast sndfile sndio soundcloud sqlite systemd
	test twolame udisks vorbis wavpack webdav wildmidi upnp
	yajl zeroconf zip zlib"

OUTPUT_PLUGINS="alsa ao fifo jack network openal oss pipe pipewire pulseaudio snapcast sndio recorder"
DECODER_PLUGINS="audiofile faad ffmpeg flac fluidsynth mad mikmod
	modplug mpg123 musepack opus openmpt flac sid vorbis wavpack wildmidi"
ENCODER_PLUGINS="audiofile flac lame twolame vorbis"

REQUIRED_USE="
	|| ( ${OUTPUT_PLUGINS} )
	|| ( ${DECODER_PLUGINS} )
	network? ( || ( ${ENCODER_PLUGINS} ) )
	recorder? ( || ( ${ENCODER_PLUGINS} ) )
	qobuz? ( curl soundcloud )
	snapcast? ( yajl )
	soundcloud? ( curl qobuz yajl )
	udisks? ( dbus )
	upnp? ( curl expat )
	webdav? ( curl expat )
"

RESTRICT="!test? ( test )"

RDEPEND="
	acct-user/mpd
	dev-libs/libfmt:=
	dev-libs/libpcre2
	media-libs/libogg
	alsa? (
		media-libs/alsa-lib
		media-sound/alsa-utils
	)
	ao? ( media-libs/libao:=[alsa?,pulseaudio?] )
	audiofile? ( media-libs/audiofile:= )
	bzip2? ( app-arch/bzip2 )
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
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	fluidsynth? ( media-sound/fluidsynth )
	gme? ( >=media-libs/game-music-emu-0.6.0_pre20120802 )
	icu? (
		dev-libs/icu:=
		virtual/libiconv
	)
	id3tag? ( media-libs/libid3tag:= )
	io-uring? ( sys-libs/liburing:= )
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
	network? ( >=media-libs/libshout-2.4.0 )
	nfs? ( net-fs/libnfs )
	openal? ( media-libs/openal )
	openmpt? ( media-libs/libopenmpt )
	opus? ( media-libs/opus )
	pulseaudio? ( media-libs/libpulse )
	pipewire? ( media-video/pipewire:= )
	qobuz? ( dev-libs/libgcrypt:0 )
	samba? ( net-fs/samba )
	selinux? ( sec-policy/selinux-mpd )
	sid? ( || (
		media-libs/libsidplay:2
		media-libs/libsidplayfp
	) )
	snapcast? ( media-sound/snapcast )
	sndfile? ( media-libs/libsndfile )
	sndio? ( media-sound/sndio )
	sqlite? ( dev-db/sqlite:3 )
	systemd? ( sys-apps/systemd:= )
	twolame? ( media-sound/twolame )
	udisks? ( sys-fs/udisks:2 )
	upnp? ( net-libs/libupnp:0 )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	wildmidi? ( media-sound/wildmidi )
	yajl? ( >=dev-libs/yajl-2:= )
	zeroconf? ( net-dns/avahi[dbus] )
	zip? ( dev-libs/zziplib:= )
	zlib? ( sys-libs/zlib:= )
"

DEPEND="
	${RDEPEND}
	dev-libs/boost:=
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
		$(meson_use cue)
		$(meson_feature curl)
		$(meson_feature dbus)
		$(meson_use eventfd)
		$(meson_feature expat)
		$(meson_feature faad)
		$(meson_feature ffmpeg)
		$(meson_use fifo)
		$(meson_feature flac)
		$(meson_feature fluidsynth)
		$(meson_feature gme)
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
		$(meson_use pipe)
		$(meson_feature pipewire)
		$(meson_feature pulseaudio pulse)
		$(meson_feature qobuz)
		$(meson_use recorder)
		$(meson_use signalfd)
		$(meson_feature samba smbclient)
		$(meson_use snapcast)
		$(meson_feature sid sidplay)
		$(meson_feature sndfile)
		$(meson_feature sndio)
		$(meson_feature soundcloud)
		$(meson_feature libsoxr soxr)
		$(meson_feature sqlite)
		$(meson_feature systemd)
		$(meson_use test)
		$(meson_feature udisks)
		-Dupnp=$(usex upnp pupnp disabled)
		$(meson_feature vorbis)
		$(meson_feature wavpack)
		$(meson_feature wildmidi)
		$(meson_feature webdav)
		$(meson_feature yajl)
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
	append-ldflags "-L${ESYSROOT}/usr/$(get_libdir)/sidplay/builders"

	if use network; then
		emesonargs+=(
			-Dshine=disabled
			-Dshout=enabled
			$(meson_feature vorbis vorbisenc)
			-Dhttpd=true
			$(meson_feature lame)
			$(meson_feature twolame)
			$(meson_use audiofile wave_encoder)
		)
	fi

	meson_src_configure
}

src_install() {
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
			-e 's:^#log_file.*$:log_file "/var/log/mpd/mpd.log":' \
			-e 's:^#pid_file.*$:pid_file "/run/mpd/mpd.pid":' \
			"${ED}/etc/mpd.conf" || die
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${P}.logrotate" "${PN}"

	newinitd "${FILESDIR}/${P}.init-r1" "${PN}"

	keepdir /var/lib/mpd
	keepdir /var/lib/mpd/music
	keepdir /var/lib/mpd/playlists
	keepdir /var/log/mpd

	rm -r "${ED}"/usr/share/doc/mpd || die

	fowners mpd:audio -R /var/lib/mpd
	fowners mpd:audio -R /var/log/mpd
}
