# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/mediatomb/mediatomb-0.12.1-r8.ebuild,v 1.3 2014/08/29 10:30:26 nimiux Exp $

EAPI=5
inherit autotools eutils linux-info user

DEB_VER="5"
DESCRIPTION="MediaTomb is an open source UPnP MediaServer"
HOMEPAGE="http://www.mediatomb.cc/"

SRC_URI="mirror://sourceforge/mediatomb/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_VER}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

IUSE="curl debug +exif +ffmpeg flac id3tag +inotify +javascript lastfm
		libextractor +magic +mp4 mysql +sqlite +taglib thumbnail +zlib"
REQUIRED_USE="
	|| ( mysql sqlite )
	taglib? ( !id3tag )
	id3tag? ( !taglib )
	thumbnail? ( ffmpeg !libextractor )
	ffmpeg? ( !libextractor )
	libextractor? ( !ffmpeg !thumbnail )
"

DEPEND="mysql? ( virtual/mysql )
	dev-libs/expat
	id3tag? ( media-libs/id3lib )
	javascript? ( >=dev-lang/spidermonkey-1.8.5:0 )
	taglib? ( media-libs/taglib )
	sqlite? ( >=dev-db/sqlite-3 )
	lastfm? ( >=media-libs/lastfmlib-0.4 )
	exif? ( media-libs/libexif )
	libextractor? ( media-libs/libextractor )
	mp4? ( >=media-libs/libmp4v2-1.9.1_p479:0 )
	ffmpeg? ( virtual/ffmpeg )
	flac? ( media-libs/flac )
	thumbnail? ( media-video/ffmpegthumbnailer[jpeg] )
	curl? ( net-misc/curl net-misc/youtube-dl )
	magic? ( sys-apps/file )
	sys-apps/util-linux
	zlib? ( sys-libs/zlib )
	virtual/libiconv
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~INOTIFY_USER"

pkg_setup() {
	enewgroup mediatomb
	enewuser mediatomb -1 -1 /dev/null mediatomb
}

src_prepare() {
	# Apply Debians patchset
	local p dd="${WORKDIR}"/debian/patches
	sed -i -r '/^[-+]{3} /s:[.][.]/::' "${dd}"/* || die
	# We use our version as it seems to be more complete.
	sed -i '/^0010_fix_libmp4v2_build.patch/d' "${dd}"/series || die
	for p in $(<"${dd}"/series) ; do
		epatch "${dd}"/${p}
	done

	# libmp4v2 API breakage #410235
	epatch "${FILESDIR}"/${P}-libmp4v2.patch

	# Use system libuuid #270830
	epatch "${FILESDIR}"/${P}-system-uuid.patch

	# Support spidermonkey-187 #423991 #482392
	if has_version "~dev-lang/spidermonkey-1.8.7" ; then
		epatch "${FILESDIR}"/${P}-mozjs187.patch
	fi

	# Support libextractor-0.6.0 #435394
	epatch "${FILESDIR}"/${P}-libextractor.patch

	# Fix inotify and hard links
	epatch "${FILESDIR}"/${P}-inotify-hard-links.patch

	# Add support for caching thumbnails
	epatch "${FILESDIR}"/${P}-thumb-cache.patch
	epatch "${FILESDIR}"/${P}-thumbnail-locking.patch

	# Respect AR #464710
	epatch "${FILESDIR}"/${P}-system-ar.patch

	# Add flac metadata support #494398
	epatch "${FILESDIR}"/${P}-flac-metadata.patch

	# Work around broken youtube support by using youtube-dl #467110
	epatch "${FILESDIR}"/${P}-youtube-dl.patch

	epatch_user

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable curl) \
		$(use_enable curl youtube) \
		$(use_enable debug tombdebug) \
		$(use_enable exif libexif) \
		$(use_enable ffmpeg) \
		$(use_enable flac FLAC) \
		$(use_enable id3tag id3lib) \
		$(use_enable inotify) \
		$(use_enable javascript libjs) \
		$(use_enable lastfm lastfmlib) \
		$(use_enable libextractor) \
		$(use_enable magic libmagic) \
		$(use_enable mp4 libmp4v2) \
		$(use_enable mysql) \
		$(use_enable sqlite sqlite3) \
		$(use_enable taglib) \
		$(use_enable thumbnail ffmpegthumbnailer) \
		$(use_enable zlib) \
		--enable-external-transcoding \
		--enable-protocolinfo-extension
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}-0.12.1.initd ${PN}
	use mysql || sed -i -e "/use mysql/d" "${ED}"/etc/init.d/${PN}
	newconfd "${FILESDIR}"/${PN}-0.12.0.confd ${PN}

	insinto /etc/mediatomb
	newins "${FILESDIR}/${PN}-0.12.0.config" config.xml
	fperms 0600 /etc/mediatomb/config.xml
	fowners mediatomb:mediatomb /etc/mediatomb/config.xml

	keepdir /var/lib/mediatomb
	fowners mediatomb:mediatomb /var/lib/mediatomb
}

pkg_postinst() {
	if use mysql ; then
		elog "MediaTomb has been built with MySQL support and needs"
		elog "to be configured before being started."
		elog "For more information, please consult the MediaTomb"
		elog "documentation: http://mediatomb.cc/pages/documentation"
		elog
	fi

	elog "To configure MediaTomb edit:"
	elog "/etc/mediatomb/config.xml"
	elog
	elog "The MediaTomb web interface can be reached at (after the service is started):"
	elog "http://localhost:49152/"
}
