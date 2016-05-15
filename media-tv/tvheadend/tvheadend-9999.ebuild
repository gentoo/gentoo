# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3 linux-info systemd toolchain-funcs user

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"
EGIT_REPO_URI="git://github.com/tvheadend/tvheadend.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="avahi capmt constcw +cwc dbus +dvb +dvbscan ffmpeg hdhomerun libav imagecache inotify iptv satip +timeshift uriparser xmltv zlib"

RDEPEND="dev-libs/openssl:=
	virtual/libiconv
	avahi? ( net-dns/avahi )
	dbus? ( sys-apps/dbus )
	ffmpeg? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:= )
	)
	hdhomerun? ( media-libs/libhdhomerun )
	uriparser? ( dev-libs/uriparser )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	dvb? ( virtual/linuxtv-dvb-headers )
	capmt? ( virtual/linuxtv-dvb-headers )
	virtual/pkgconfig"

RDEPEND+="
	dvbscan? ( media-tv/linuxtv-dvb-apps )
	xmltv? ( media-tv/xmltv )"

CONFIG_CHECK="~INOTIFY_USER"

DOCS=( README.md )

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_prepare() {
	# remove '-Werror' wrt bug #438424
	sed -e 's:-Werror::' -i Makefile || die 'sed failed!'
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share \
		--disable-hdhomerun_static \
		--disable-libffmpeg_static \
		--disable-ccache \
		--disable-dvbscan \
		$(use_enable avahi) \
		$(use_enable capmt) \
		$(use_enable constcw) \
		$(use_enable cwc) \
		$(use_enable dbus) \
		$(use_enable dvb linuxdvb) \
		$(use_enable ffmpeg libav) \
		$(use_enable hdhomerun hdhomerun_client) \
		$(use_enable imagecache) \
		$(use_enable inotify) \
		$(use_enable iptv) \
		$(use_enable satip satip_server) \
		$(use_enable satip satip_client) \
		$(use_enable timeshift) \
		$(use_enable uriparser) \
		$(use_enable zlib)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newinitd "${FILESDIR}/tvheadend.initd" tvheadend
	newconfd "${FILESDIR}/tvheadend.confd" tvheadend

	systemd_dounit "${FILESDIR}/tvheadend.service"

	dodir /etc/tvheadend
	fperms 0700 /etc/tvheadend
	fowners tvheadend:video /etc/tvheadend
}

pkg_postinst() {
	elog "The Tvheadend web interface can be reached at:"
	elog "http://localhost:9981/"
	elog
	elog "Make sure that you change the default username"
	elog "and password via the Configuration / Access control"
	elog "tab in the web interface."
}
