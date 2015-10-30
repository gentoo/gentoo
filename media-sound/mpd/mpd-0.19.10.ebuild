# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic linux-info multilib readme.gentoo systemd user

DESCRIPTION="The Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org"
SRC_URI="http://www.musicpd.org/download/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ppc ppc64 ~sh x86 ~x86-fbsd ~x64-macos"
IUSE="adplug +alsa ao audiofile bzip2 cdio +curl debug +eventfd expat faad
	+fifo +ffmpeg flac fluidsynth +glib gme +icu +id3tag +inotify +ipv6 jack
	lame mms libav libmpdclient libsamplerate libsoxr +mad mikmod modplug
	mpg123 musepack +network nfs ogg openal opus oss pipe pulseaudio recorder
	samba selinux sid +signalfd sndfile soundcloud sqlite systemd tcpd twolame
	unicode upnp vorbis wavpack wildmidi zeroconf zip zlib"

OUTPUT_PLUGINS="alsa ao fifo jack network openal oss pipe pulseaudio recorder"
DECODER_PLUGINS="adplug audiofile faad ffmpeg flac fluidsynth mad mikmod
	modplug mpg123 musepack ogg flac sid vorbis wavpack wildmidi"
ENCODER_PLUGINS="audiofile flac lame twolame vorbis"

REQUIRED_USE="|| ( ${OUTPUT_PLUGINS} )
	|| ( ${DECODER_PLUGINS} )
	ao? ( glib )
	gme? ( glib )
	jack? ( glib )
	network? ( || ( ${ENCODER_PLUGINS} )
		glib )
	recorder? ( || ( ${ENCODER_PLUGINS} ) )
	sid? ( glib )
	soundcloud? ( glib )
	sqlite? ( glib )
	opus? ( ogg )
	upnp? ( expat )
	vorbis? ( glib )
	wavpack? ( glib )"

CDEPEND="!<sys-cluster/mpich2-1.4_rc2
	adplug? ( media-libs/adplug )
	alsa? ( media-sound/alsa-utils
		media-libs/alsa-lib )
	ao? ( media-libs/libao[alsa?,pulseaudio?] )
	audiofile? ( media-libs/audiofile )
	bzip2? ( app-arch/bzip2 )
	cdio? ( dev-libs/libcdio-paranoia )
	curl? ( net-misc/curl )
	expat? ( dev-libs/expat )
	faad? ( media-libs/faad2 )
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	flac? ( media-libs/flac[ogg?] )
	fluidsynth? ( media-sound/fluidsynth )
	glib? ( dev-libs/glib:2 )
	gme? ( >=media-libs/game-music-emu-0.6.0_pre20120802 )
	icu? ( dev-libs/icu:= )
	id3tag? ( media-libs/libid3tag )
	jack? ( media-sound/jack-audio-connection-kit )
	lame? ( network? ( media-sound/lame ) )
	libmpdclient? ( media-libs/libmpdclient )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod:0 )
	mms? ( media-libs/libmms )
	modplug? ( media-libs/libmodplug )
	mpg123? ( >=media-sound/mpg123-1.12.2 )
	musepack? ( media-sound/musepack-tools )
	network? ( >=media-libs/libshout-2
		!lame? ( !vorbis? ( media-libs/libvorbis ) ) )
	nfs? ( net-fs/libnfs )
	ogg? ( media-libs/libogg )
	openal? ( media-libs/openal )
	opus? ( media-libs/opus )
	pulseaudio? ( media-sound/pulseaudio )
	samba? ( || ( <net-fs/samba-4.0.25[smbclient] >=net-fs/samba-4.0.25 ) )
	sid? ( media-libs/libsidplay:2 )
	sndfile? ( media-libs/libsndfile )
	soundcloud? ( >=dev-libs/yajl-2 )
	libsoxr? ( media-libs/soxr )
	sqlite? ( dev-db/sqlite:3 )
	systemd? ( sys-apps/systemd )
	tcpd? ( sys-apps/tcp-wrappers )
	twolame? ( media-sound/twolame )
	upnp? ( net-libs/libupnp )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	wildmidi? ( media-sound/wildmidi )
	zeroconf? ( net-dns/avahi[dbus] )
	zip? ( dev-libs/zziplib )
	zlib? ( sys-libs/zlib )"
DEPEND="${CDEPEND}
	dev-libs/boost
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-mpd )
"

pkg_setup() {
	use network || ewarn "Icecast and Shoutcast streaming needs networking."
	use fluidsynth && ewarn "Using fluidsynth is discouraged by upstream."

	enewuser mpd "" "" "/var/lib/mpd" audio

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
}

src_prepare() {
	DOC_CONTENTS="If you will be starting mpd via /etc/init.d/mpd, please make
		sure that MPD's pid_file is _set_."

	cp -f doc/mpdconf.example doc/mpdconf.dist || die "cp failed"
	epatch "${FILESDIR}"/${PN}-0.18.conf.patch
}

src_configure() {
	local mpdconf="--enable-database --disable-roar --disable-documentation
		--enable-dsd --enable-largefile --disable-osx --disable-shine-encoder
		--disable-solaris-output --enable-tcp --enable-un --disable-werror
		--docdir=${EPREFIX}/usr/share/doc/${PF}"

	if use network; then
		mpdconf+=" --enable-shout $(use_enable vorbis vorbis-encoder)
			--enable-httpd-output $(use_enable lame lame-encoder)
			$(use_enable twolame twolame-encoder)
			$(use_enable audiofile wave-encoder)"
	else
		mpdconf+=" --disable-shout --disable-vorbis-encoder
			--disable-httpd-output --disable-lame-encoder
			--disable-twolame-encoder --disable-wave-encoder"
	fi

	if use samba || use upnp; then
		mpdconf+=" --enable-neighbor-plugins"
	fi

	append-lfs-flags
	append-ldflags "-L/usr/$(get_libdir)/sidplay/builders"

	econf \
		$(use_enable eventfd)		\
		$(use_enable signalfd)		\
		$(use_enable libmpdclient)	\
		$(use_enable expat)			\
		$(use_enable upnp)			\
		$(use_enable adplug)		\
		$(use_enable alsa)			\
		$(use_enable ao)			\
		$(use_enable audiofile)		\
		$(use_enable zlib)			\
		$(use_enable bzip2)			\
		$(use_enable cdio cdio-paranoia) \
		$(use_enable curl)			\
		$(use_enable samba smbclient) \
		$(use_enable nfs)			\
		$(use_enable debug)			\
		$(use_enable ffmpeg)		\
		$(use_enable fifo)			\
		$(use_enable flac)			\
		$(use_enable fluidsynth)	\
		$(use_enable gme)			\
		$(use_enable id3tag id3)	\
		$(use_enable inotify)		\
		$(use_enable ipv6)			\
		$(use_enable cdio iso9660)	\
		$(use_enable jack)			\
		$(use_enable soundcloud)	\
		$(use_enable tcpd libwrap)	\
		$(use_enable libsamplerate lsr) \
		$(use_enable libsoxr soxr)	\
		$(use_enable mad)			\
		$(use_enable mikmod)		\
		$(use_enable mms)			\
		$(use_enable modplug)		\
		$(use_enable musepack mpc)	\
		$(use_enable mpg123)		\
		$(use_enable openal)		\
		$(use_enable opus)			\
		$(use_enable oss)			\
		$(use_enable pipe pipe-output) \
		$(use_enable pulseaudio pulse) \
		$(use_enable recorder recorder-output) \
		$(use_enable sid sidplay)	\
		$(use_enable sndfile sndfile) \
		$(use_enable sqlite)		\
		$(use_enable systemd systemd-daemon) \
		$(use_enable vorbis)		\
		$(use_enable wavpack)		\
		$(use_enable wildmidi)		\
		$(use_enable zip zzip)		\
		$(use_enable icu)			\
		$(use_enable glib)			\
		$(use_enable faad aac)		\
		$(use_with zeroconf zeroconf avahi) \
		"$(systemd_with_unitdir)"	\
		${mpdconf}
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc
	newins doc/mpdconf.dist mpd.conf

	newinitd "${FILESDIR}"/${PN}2.init ${PN}

	if use unicode; then
		sed -i -e 's:^#filesystem_charset.*$:filesystem_charset "UTF-8":' \
			"${ED}"/etc/mpd.conf || die "sed failed"
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	use prefix || diropts -m0755 -o mpd -g audio
	dodir /var/lib/mpd
	keepdir /var/lib/mpd
	dodir /var/lib/mpd/music
	keepdir /var/lib/mpd/music
	dodir /var/lib/mpd/playlists
	keepdir /var/lib/mpd/playlists

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	# also change the homedir if the user has existed before
	usermod -d "/var/lib/mpd" mpd
}
