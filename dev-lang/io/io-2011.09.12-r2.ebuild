# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils

DESCRIPTION="Io is a small, prototype-based programming language"
HOMEPAGE="http://www.iolanguage.com"
SRC_URI="mirror://gentoo/${P}.tar.gz
		https://dev.gentoo.org/~araujo/snapshots/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cgi clutter dbi doc editline google gui http image libffi libxml2
	lzo md5sum ncurses ogg opengl postgres pcre python readline sha1 sndfile sockets
	sqlite syslog theora threads truetype twitter vorbis xmpp zlib"
DEPEND="clutter? ( media-libs/clutter )
		dbi? ( dev-db/libdbi )
		editline? ( dev-libs/libedit )
		image? ( virtual/jpeg
			media-libs/tiff
			media-libs/libpng )
		xmpp? ( net-libs/loudmouth )
		libffi? ( virtual/libffi )
		libxml2? ( dev-libs/libxml2 )
		lzo? ( dev-libs/lzo )
		ncurses? ( sys-libs/ncurses )
		ogg? ( media-libs/libogg )
		opengl? ( virtual/opengl )
		pcre? ( dev-libs/libpcre )
		postgres? ( dev-db/postgresql[server] )
		readline? ( sys-libs/readline )
		sndfile? ( media-libs/libsndfile )
		sqlite? ( >=dev-db/sqlite-3.0.0 )
		theora? ( media-libs/libtheora )
		truetype? ( media-libs/freetype )
		vorbis? ( media-libs/libvorbis )
		zlib? ( sys-libs/zlib )"
RDEPEND=""
REQUIRED_USE="vorbis? ( ogg )"

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo-fixes.patch"
	# Fix multilib strict check (bug #430496)
	sed  -i 's/DESTINATION lib/DESTINATION lib${LIB_SUFFIX}/' \
			addons/*/CMakeLists.txt \
			libs/*/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable cgi CGI)
		$(cmake-utils_use_enable clutter CLUTTER)
		$(cmake-utils_use_enable dbi DBI)
		$(cmake-utils_use_enable editline EDITLINE)
		$(cmake-utils_use_enable libffi CFFI)
		$(cmake-utils_use_enable gui FLUX)
		$(cmake-utils_use_enable google GOOGLESEARCH)
		$(cmake-utils_use_enable http HTTPCLIENT)
		$(cmake-utils_use_enable xmpp LOUDMOUTH)
		$(cmake-utils_use_enable image IMAGE)
		$(cmake-utils_use_enable libxml2 LIBXML2)
		$(cmake-utils_use_enable lzo LZO)
		$(cmake-utils_use_enable md5sum MD5SUM)
		$(cmake-utils_use_enable ncurses CURSES)
		$(cmake-utils_use_enable ogg OGG)
		$(cmake-utils_use_enable opengl OPENGL)
		$(cmake-utils_use_enable postgres POSTGRESQL)
		$(cmake-utils_use_enable python PYTHON)
		$(cmake-utils_use_enable readline READLINE)
		$(cmake-utils_use_enable pcre REGEX)
		$(cmake-utils_use_enable sndfile LIBSNDFILE)
		$(cmake-utils_use_enable sha1 SHA1)
		$(cmake-utils_use_enable sockets SOCKET)
		$(cmake-utils_use_enable sqlite SQLITE3)
		$(cmake-utils_use_enable syslog SYSLOG)
		$(cmake-utils_use_enable theora THEORA)
		$(cmake-utils_use_enable threads THREADS)
		$(cmake-utils_use_enable truetype FONT)
		$(cmake-utils_use_enable twitter TWITTER )
		$(cmake-utils_use_enable vorbis VORBIS)
		$(cmake-utils_use_enable zlib ZLIB)
		-DCMAKE_SKIP_RPATH=ON
	)
	cmake-utils_src_configure
}

src_compile() {
	# Fix bug #414421
	cmake-utils_src_compile -j1
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		dodoc docs/docs.css docs/*.html
	fi
}
