# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TODO:
# Add --enable-spotify when it works

EAPI=5

inherit autotools eutils user

DESCRIPTION="A DAAP (iTunes) media server"
HOMEPAGE="https://github.com/ejurgensen/forked-daapd"
SRC_URI="https://github.com/ejurgensen/forked-daapd/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa flac itunes lastfm mpd musepack"

# Note: mpd support appears to be standalone, e.g. --enable-mpd doesn't
# result in additional linkage.
RDEPEND="
	dev-db/sqlite:3
	dev-libs/antlr-c:0
	dev-libs/confuse
	dev-libs/libevent
	dev-libs/libgcrypt:0
	dev-libs/libunistring
	dev-libs/mxml[threads]
	media-libs/alsa-lib
	net-dns/avahi[dbus]
	virtual/ffmpeg

	flac? ( media-libs/flac )
	itunes? ( app-pda/libplist )
	lastfm? ( net-misc/curl )
	musepack? ( media-libs/taglib )
"

DEPEND="
	dev-java/antlr:3.5
	${RDEPEND}
"

pkg_setup() {
	enewuser daapd
	enewgroup daapd
}

src_prepare() {
	# Fixed in 23.3.
	epatch "${FILESDIR}/${P}-fix-arg-enable.patch"

	# https://github.com/ejurgensen/forked-daapd/pull/185
	epatch "${FILESDIR}/antlr-3.5.patch"

	eautoreconf
}

src_configure() {
	ac_cv_prog_ANTLR=antlr3.5 \
	econf \
		--with-alsa \
		$(use_enable flac) \
		$(use_enable musepack) \
		$(use_enable itunes) \
		$(use_enable lastfm) \
		$(use_enable mpd)
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}/daapd.initd" daapd
	newconfd "${FILESDIR}/daapd.confd" daapd

	# dodir by itself fails in the likely case of /srv/music having a
	# volume mounted already.
	test -d /srv/music || dodir /srv/music

	fowners -R daapd:daapd /var/lib/cache/forked-daapd
}
