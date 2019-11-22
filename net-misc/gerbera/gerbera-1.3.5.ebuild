# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils linux-info systemd tmpfiles user

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/gerbera/${PN}.git"
	KEYWORDS=""
	SRC_URI=""
	inherit git-r3
else
	SRC_URI="https://github.com/gerbera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="UPnP Media Server (Based on MediaTomb)"
HOMEPAGE="https://github.com/gerbera/gerbera"

LICENSE="GPL-2"
SLOT="0"
IUSE="curl debug +exif exiv2 +ffmpeg ffmpegthumbnailer +javascript lastfm libav +magic mysql protocol-extensions systemd +taglib"

DEPEND="
	!!net-misc/mediatomb
	>=net-libs/libupnp-1.8.3[ipv6,reuseaddr]
	>=dev-db/sqlite-3
	dev-libs/expat
	mysql? ( dev-db/mysql-connector-c )
	javascript? ( dev-lang/duktape )
	taglib? ( >=media-libs/taglib-1.11 )
	lastfm? ( >=media-libs/lastfmlib-0.4 )
	exif? ( media-libs/libexif )
	exiv2? ( media-gfx/exiv2 )
	ffmpeg? (
		libav? ( >=media-video/libav-10:0= )
		!libav? ( >=media-video/ffmpeg-2.2:0= )
	)
	ffmpegthumbnailer? ( media-video/ffmpegthumbnailer )
	curl? ( net-misc/curl net-misc/youtube-dl )
	magic? ( sys-apps/file )
	sys-apps/util-linux
	sys-libs/zlib
	virtual/libiconv
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~INOTIFY_USER"

pkg_setup() {
	linux-info_pkg_setup

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_configure() {
	local mycmakeargs=(
		-DWITH_CURL="$(usex curl)" \
		-DWITH_DEBUG="$(usex debug)" \
		-DWITH_EXIF="$(usex exif)" \
		-DWITH_EXIV2="$(usex exiv2)" \
		-DWITH_AVCODEC="$(usex ffmpeg)" \
		-DWITH_FFMPEGTHUMBNAILER="$(usex ffmpegthumbnailer)" \
		-DWITH_JS="$(usex javascript)" \
		-DWITH_LASTFM="$(usex lastfm)" \
		-DWITH_MAGIC="$(usex magic)" \
		-DWITH_MYSQL="$(usex mysql)"
		-DWITH_PROTOCOL_EXTENSIONS="$(usex protocol-extensions)" \
		-DWITH_SYSTEMD="$(usex systemd)" \
		-DWITH_TAGLIB="$(usex taglib)" \
		-DWITH_INOTIFY=1
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}/${PN}-1.0.0.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-1.0.0.confd" "${PN}"

	insinto /etc/${PN}
	newins "${FILESDIR}/${PN}-1.3.0.config" config.xml
	fperms 0640 /etc/${PN}/config.xml
	fowners root:gerbera /etc/${PN}/config.xml

	keepdir /var/lib/${PN}
	fowners ${PN}:${PN} /var/lib/${PN}
}

pkg_postinst() {
	if use mysql ; then
		elog "Gerbera has been built with MySQL support and needs"
		elog "to be configured before being started. By default"
		elog "SQLite will be used."
	fi
}
