# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/goaccess/goaccess-0.9.ebuild,v 1.1 2015/04/29 22:47:56 idella4 Exp $

EAPI="5"

inherit eutils

DESCRIPTION="A real-time web log analyzer and interactive viewer that runs in a terminal"
HOMEPAGE="http://goaccess.io"
SRC_URI="http://tar.goaccess.io/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

IUSE="btree debug geoip tokyocabinet unicode"

REQUIRED_USE="btree? ( tokyocabinet )"

RDEPEND="
	sys-libs/ncurses[unicode?]
	geoip? ( dev-libs/geoip )
	!tokyocabinet? ( dev-libs/glib:2 )
	tokyocabinet? (
		dev-db/tokyocabinet
		btree? (
			app-arch/bzip2
			sys-libs/zlib
		)
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch_user

	# Fix path to GeoIP bases in config
	sed -e s':/usr/local:/usr:' -i config/goaccess.conf || die
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable geoip) \
		$(use_enable unicode utf8) \
		$(use_enable tokyocabinet tcb) \
		$(use_enable btree bzip) \
		$(use_enable btree zlib) \
		$(usex tokyocabinet "--enable-tcb=$(usex btree btree memhash)" '')
}
