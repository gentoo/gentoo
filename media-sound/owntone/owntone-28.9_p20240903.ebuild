# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

GITREV="40c22e3d2f716177ad737998f3ef909f20c4acfa"
DESCRIPTION="DAAP (iTunes) and MPD media server"
HOMEPAGE="https://owntone.github.io/owntone-server"
SRC_URI="https://github.com/owntone/owntone-server/archive/${GITREV}.tar.gz -> ${P}-${GITREV:0:8}.tar.gz
	https://github.com/grobian/owntone-mpd/releases/download/mpd-0.24-r1/${PN}-${GITREV:0:7}-mpd-0.24-r1.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+alsa +chromecast"
S="${WORKDIR}/${PN}-server-${GITREV}"

RDEPEND="
	app-pda/libplist
	dev-db/sqlite:3
	dev-libs/confuse
	dev-libs/json-c
	dev-libs/libevent
	dev-libs/libgcrypt
	dev-libs/libsodium
	dev-libs/libunistring
	dev-libs/libxml2
	dev-libs/mxml:0
	dev-libs/protobuf-c
	media-libs/alsa-lib
	media-video/ffmpeg
	net-dns/avahi
	net-libs/libwebsockets
	net-misc/curl
	sys-devel/gettext
	sys-libs/zlib
	acct-group/audio
	acct-user/owntone
	alsa? ( media-libs/alsa-lib )
	chromecast? ( net-libs/gnutls media-video/ffmpeg[opus] )
"
DEPEND="${RDEPEND}
	dev-util/gperf
	sys-apps/gawk
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${DISTDIR}"/${PN}-${GITREV:0:7}-mpd-0.24-r1.patch
)

src_prepare() {
	default

	eautoreconf

	# fix log path, and enable songs/cache databases
	sed -i \
		-e "/logfile = /s:= .*$:= ${EPREFIX}/var/log/owntone/owntone.log:" \
		-e "/\(db_path\|cache_path\) =/s:/cache/:/:" \
		-e "/\(db_path\|cache_path\) =/s:^#::" \
		owntone.conf.in || die
}

src_configure() {
	econf \
		--without-pulseaudio \
		--with-libwebsockets \
		--with-avahi \
		--with-user=owntone \
		--with-group=audio \
		$(use_with alsa) \
		$(use_enable chromecast) || die
}

src_install() {
	default

	rm -Rf "${ED}"/var/lib  # all empty dirs
	find "${ED}" -name "*.la" -delete

	keepdir /var/lib/owntone
	keepdir /var/log/owntone
	fowners owntone /var/log/owntone

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
