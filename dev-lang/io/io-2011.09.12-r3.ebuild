# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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

PATCHES=(
	"${FILESDIR}/${P}-gentoo-fixes.patch"
)

src_prepare() {
	default

	# Fix multilib strict check (bug #430496)
	sed  -i 's/DESTINATION lib/DESTINATION lib${LIB_SUFFIX}/' \
			addons/*/CMakeLists.txt \
			libs/*/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CGI=$(usex cgi)
		-DENABLE_CLUTTER=$(usex clutter)
		-DENABLE_DBI=$(usex dbi)
		-DENABLE_EDITLINE=$(usex editline)
		-DENABLE_CFFI=$(usex libffi)
		-DENABLE_FLUX=$(usex gui)
		-DENABLE_GOOGLESEARCH=$(usex google)
		-DENABLE_HTTPCLIENT=$(usex http)
		-DENABLE_LOUDMOUTH=$(usex xmpp)
		-DENABLE_IMAGE=$(usex image)
		-DENABLE_LIBXML2=$(usex libxml2)
		-DENABLE_LZO=$(usex lzo)
		-DENABLE_MD5SUM=$(usex md5sum)
		-DENABLE_CURSES=$(usex ncurses)
		-DENABLE_OGG=$(usex ogg)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_POSTGRESQL=$(usex postgres)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_READLINE=$(usex readline)
		-DENABLE_REGEX=$(usex pcre)
		-DENABLE_LIBSNDFILE=$(usex sndfile)
		-DENABLE_SHA1=$(usex sha1)
		-DENABLE_SOCKET=$(usex sockets)
		-DENABLE_SQLITE3=$(usex sqlite)
		-DENABLE_SYSLOG=$(usex syslog)
		-DENABLE_THEORA=$(usex theora)
		-DENABLE_THREADS=$(usex threads)
		-DENABLE_FONT=$(usex truetype)
		-DENABLE_TWITTER=$(usex twitter)
		-DENABLE_VORBIS=$(usex vorbis)
		-DENABLE_ZLIB=$(usex zlib)
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
