# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="A real-time web log analyzer and interactive viewer that runs in a terminal"
HOMEPAGE="http://goaccess.io"
SRC_URI="http://tar.goaccess.io/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

IUSE="btree debug geoip bzip2 memhash unicode zlib"

REQUIRED_USE="btree? ( !memhash )"

RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses[unicode?]
	geoip? ( dev-libs/geoip )
	btree? ( dev-db/tokyocabinet )
	memhash? ( dev-db/tokyocabinet )
	zlib? ( sys-libs/zlib )
	bzip2? ( app-arch/bzip2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Fix path to GeoIP bases in config
	sed -e s':/usr/local:/usr:' -i config/goaccess.conf || die
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable geoip) \
		$(use_enable bzip2 bzip) \
		$(use_enable unicode utf8) \
		$(use_enable zlib) \
		$(use memhash && echo "--enable-tcb=memhash") \
		$(use btree && echo "--enable-tcb=btree")

	epatch_user
}
