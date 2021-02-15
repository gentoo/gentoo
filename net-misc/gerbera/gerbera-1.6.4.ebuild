# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake eutils linux-info systemd tmpfiles

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/gerbera/${PN}.git"
	SRC_URI=""
	inherit git-r3
else
	SRC_URI="https://github.com/gerbera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="UPnP Media Server"
HOMEPAGE="https://gerbera.io"

LICENSE="GPL-2"
SLOT="0"
IUSE="curl debug +exif exiv2 +ffmpeg ffmpegthumbnailer +javascript lastfm +magic +matroska mysql systemd +taglib"

DEPEND="
	acct-user/gerbera
	>=net-libs/libupnp-1.12.1:=[ipv6,reuseaddr]
	>=dev-db/sqlite-3
	dev-libs/spdlog:=
	dev-libs/pugixml
	dev-libs/libfmt:0=
	mysql? ( dev-db/mysql-connector-c )
	javascript? ( dev-lang/duktape:= )
	taglib? ( >=media-libs/taglib-1.11 )
	lastfm? ( >=media-libs/lastfmlib-0.4 )
	exif? ( media-libs/libexif )
	exiv2? ( media-gfx/exiv2 )
	ffmpeg? ( >=media-video/ffmpeg-2.2:0= )
	ffmpegthumbnailer? ( media-video/ffmpegthumbnailer )
	curl? ( net-misc/curl )
	magic? ( sys-apps/file )
	matroska? ( media-libs/libmatroska )
	sys-apps/util-linux
	sys-libs/zlib
	virtual/libiconv
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~INOTIFY_USER"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-incomplete-type-iohandler.patch"
)

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
		-DWITH_MATROSKA="$(usex matroska)" \
		-DWITH_MYSQL="$(usex mysql)"
		-DWITH_SYSTEMD="$(usex systemd)" \
		-DWITH_TAGLIB="$(usex taglib)" \
		-DWITH_INOTIFY=1
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}/${PN}-1.0.0.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-1.0.0.confd" "${PN}"

	insinto /etc/${PN}
	newins "${FILESDIR}/${PN}-1.3.0.config" config.xml
	fperms 0640 /etc/${PN}/config.xml
	fowners root:gerbera /etc/${PN}/config.xml
}

pkg_postinst() {
	if use mysql ; then
		elog "Gerbera has been built with MySQL support and needs"
		elog "to be configured before being started. By default"
		elog "SQLite will be used."
	fi
}
