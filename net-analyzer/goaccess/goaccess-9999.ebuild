# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/allinurl/${PN}.git"

inherit autotools git-r3

DESCRIPTION="A real-time web log analyzer and interactive viewer that runs in a terminal"
HOMEPAGE="https://goaccess.io"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="btree bzip2 debug geoip geoipv2 getline libressl tokyocabinet ssl unicode zlib"
REQUIRED_USE="btree? ( tokyocabinet ) bzip2? ( btree ) geoipv2? ( geoip ) zlib? ( btree )"

BDEPEND="virtual/pkgconfig"
RDEPEND="sys-libs/ncurses:0=[unicode?]
	geoip? (
		!geoipv2? ( dev-libs/geoip )
		geoipv2? ( dev-libs/libmaxminddb:0= )
	)
	!tokyocabinet? ( dev-libs/glib:2 )
	tokyocabinet? (
		dev-db/tokyocabinet[bzip2?,zlib?]
		btree? (
			bzip2? ( app-arch/bzip2 )
			zlib? ( sys-libs/zlib )
		)
	)
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Change path to GeoIP bases in config
	sed -i -e s':/usr/local:/usr:' config/goaccess.conf || die "sed failed for goaccess.conf"

	eautoreconf
}

src_configure() {
	econf \
		"$(use_enable bzip2 bzip)" \
		"$(use_enable zlib)" \
		"$(use_enable debug)" \
		"$(use_enable geoip geoip "$(usex geoipv2 mmdb legacy)")" \
		"$(use_enable tokyocabinet tcb "$(usex btree btree memhash)")" \
		"$(use_enable unicode utf8)" \
		"$(use_with getline)" \
		"$(use_with ssl openssl)"
}
