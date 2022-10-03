# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info meson systemd xdg

DESCRIPTION="The Music Player Daemon (mpd)"
HOMEPAGE="https://www.musicpd.org https://github.com/MusicPlayerDaemon/MPD"
SRC_URI="https://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 ~riscv x86"
IUSE="+alsa ao +audiofile bzip2 cdio chromaprint +cue +curl doc +dbus
	+eventfd expat faad +ffmpeg +fifo flac fluidsynth gme +icu +id3tag +inotify
	jack lame libmpdclient libsamplerate libsoxr +mad mikmod mms
	modplug mpg123 musepack +network nfs openal openmpt opus oss pipe pipewire pulseaudio qobuz
	recorder samba selinux sid signalfd snapcast sndfile sndio soundcloud sqlite systemd
	test twolame udisks vorbis wavpack webdav wildmidi upnp
	zeroconf zip zlib"

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
	soundcloud? ( curl qobuz )
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
	sys-libs/liburing:=
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
	pulseaudio? ( media-sound/pulseaudio )
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
	soundcloud? ( >=dev-libs/yajl-2:= )
	sqlite? ( dev-db/sqlite:3 )
	systemd? ( sys-apps/systemd:= )
	twolame? ( media-sound/twolame )
	udisks? ( sys-fs/udisks:2 )
	upnp? ( net-libs/libupnp:0 )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	wildmidi? ( media-sound/wildmidi )
	zeroconf? ( net-dns/avahi[dbus] )
	zip? ( dev-libs/zziplib:= )
	zlib? ( sys-libs/zlib:= )"

DEPEND="${RDEPEND}
	dev-libs/boost:=
	test? ( dev-cpp/gtest )"

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

	if use eventfd || use signalfd || use inotify; then
		linux-info_pkg_setup
	fi

	elog "If you will be starting mpd via /etc/init.d/mpd, please make sure that MPD's pid_file is _set_."
}

src_prepare() {
	 sed -i \
		-e 's:^#filesystem_charset.*$:filesystem_charset "UTF-8":' \
		-e 's:^#user.*$:user "mpd":' \
		-e 's:^#bind_to_address.*any.*$:bind_to_address "localhost":' \
		-e 's:^#bind_to_address.*$:bind_to_address "/var/lib/mpd/socket":' \
		-e 's:^#music_directory.*$:music_directory "/var/lib/mpd/music":' \
		-e 's:^#playlist_directory.*$:playlist_directory "/var/lib/mpd/playlists":' \
		-e 's:^#db_file.*$:db_file "/var/lib/mpd/database":' \
		-e 's:^#log_file.*$:log_file "/var/lib/mpd/log":' \
		-e 's:^#pid_file.*$:pid_file "/var/lib/mpd/pid":' \
		-e 's:^#state_file.*$:state_file "/var/lib/mpd/state":' \
		doc/mpdconf.example || die
	default
}

src_configure() {
	local emesonargs=(
		$(meson_feature bzip2)
		$(meson_feature cdio cdio_paranoia)
		$(meson_feature chromaprint)
		$(meson_use cue)
		$(meson_feature curl)
		$(meson_feature dbus)
		$(meson_use eventfd)
		$(meson_feature expat)
		$(meson_feature icu)
		$(meson_feature id3tag)
		$(meson_use inotify)
		-Dipv6=enabled
		$(meson_feature cdio iso9660)
		$(meson_feature libmpdclient)
		$(meson_feature libsamplerate)
		$(meson_feature mms)
		$(meson_feature nfs)
		$(meson_use signalfd)
		$(meson_feature samba smbclient)
		$(meson_feature libsoxr soxr)
		$(meson_feature sqlite)
		$(meson_feature systemd)
		$(meson_use test)
		$(meson_feature udisks)
		-Dupnp=$(usex upnp pupnp disabled)
		$(meson_feature webdav)
		-Dzeroconf=$(usex zeroconf avahi disabled)
		$(meson_feature zlib)
		$(meson_feature zip zzip)
	)

	emesonargs+=(
		$(meson_feature alsa)
		$(meson_feature ao)
		$(meson_use fifo)
		$(meson_feature jack)
		$(meson_feature openal)
		$(meson_feature oss)
		$(meson_use pipe)
		$(meson_feature pipewire)
		$(meson_feature pulseaudio pulse)
		$(meson_use recorder)
		$(meson_use snapcast)
		$(meson_feature sndio)
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

	emesonargs+=(
		# media-libs/adplug is not packaged anymore
		-Dadplug=disabled
		$(meson_feature audiofile)
		$(meson_feature faad)
		$(meson_feature ffmpeg)
		$(meson_feature flac)
		$(meson_feature fluidsynth)
		$(meson_feature gme)
		$(meson_feature mad)
		$(meson_feature mikmod)
		$(meson_feature modplug)
		$(meson_feature musepack mpcdec)
		$(meson_feature mpg123)
		$(meson_feature openmpt)
		$(meson_feature opus)
		$(meson_feature sid sidplay)
		$(meson_feature sndfile)
		$(meson_feature vorbis)
		$(meson_feature wavpack)
		$(meson_feature wildmidi)
		$(meson_feature qobuz)
		$(meson_feature soundcloud)

		--libdir="/usr/$(get_libdir)"
		$(meson_feature doc documentation)
		-Dsolaris_output=disabled

		-Ddatabase=true
		-Ddsd=true
		-Dio_uring=enabled
		-Dtcp=true

		-Dsystemd_system_unit_dir="$(systemd_get_systemunitdir)"
		-Dsystemd_user_unit_dir="$(systemd_get_userunitdir)"

		$(meson_feature icu iconv)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /etc
	newins doc/mpdconf.example mpd.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}-0.21.1.logrotate ${PN}

	newinitd "${FILESDIR}"/${PN}-0.21.4.init ${PN}

	sed -i -e 's:^#filesystem_charset.*$:filesystem_charset "UTF-8":' "${ED}"/etc/mpd.conf || die "sed failed"

	keepdir /var/lib/mpd
	keepdir /var/lib/mpd/music
	keepdir /var/lib/mpd/playlists

	rm -r "${ED}"/usr/share/doc/mpd || die

	fowners mpd:audio -R /var/lib/mpd

}
