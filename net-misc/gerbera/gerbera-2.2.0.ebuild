# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info

DESCRIPTION="UPnP Media Server"
HOMEPAGE="https://gerbera.io"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/gerbera/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/gerbera/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="curl debug +exif exiv2 +ffmpeg ffmpegthumbnailer +javascript +magic +matroska mysql systemd +taglib"

RDEPEND="
	acct-user/gerbera
	dev-db/sqlite
	dev-libs/libebml:=
	dev-libs/libfmt:=
	dev-libs/pugixml
	dev-libs/spdlog:=
	net-libs/libupnp:=[ipv6(+),reuseaddr,-blocking-tcp]
	sys-apps/util-linux
	sys-libs/zlib
	virtual/libiconv
	curl? ( net-misc/curl )
	exif? ( media-libs/libexif )
	exiv2? ( media-gfx/exiv2:= )
	ffmpeg? ( media-video/ffmpeg:= )
	ffmpegthumbnailer? ( media-video/ffmpegthumbnailer )
	javascript? ( dev-lang/duktape:= )
	magic? ( sys-apps/file )
	matroska? ( media-libs/libmatroska:= )
	mysql? ( dev-db/mysql-connector-c:= )
	taglib? ( media-libs/taglib )
"

DEPEND="${RDEPEND}"

CONFIG_CHECK="~INOTIFY_USER"

src_configure() {
	local mycmakeargs=(
		-DWITH_AVCODEC=$(usex ffmpeg)
		-DWITH_CURL=$(usex curl)
		-DWITH_DEBUG=$(usex debug)
		-DWITH_EXIF=$(usex exif)
		-DWITH_EXIV2=$(usex exiv2)
		-DWITH_FFMPEGTHUMBNAILER=$(usex ffmpegthumbnailer)
		-DWITH_INOTIFY=ON
		-DWITH_JS=$(usex javascript)
		-DWITH_LASTFM=OFF
		-DWITH_MAGIC=$(usex magic)
		-DWITH_MATROSKA=$(usex matroska)
		-DWITH_MYSQL=$(usex mysql)
		-DWITH_SYSTEMD=$(usex systemd)
		-DWITH_TAGLIB=$(usex taglib)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/${PN}-1.0.0.initd ${PN}
	newconfd "${FILESDIR}"/${PN}-1.0.0.confd ${PN}

	insinto /etc/${PN}
	newins "${FILESDIR}"/${PN}-1.3.0.config config.xml
	fperms 0640 /etc/${PN}/config.xml
	fowners root:gerbera /etc/${PN}/config.xml
}

pkg_postinst() {
	if use mysql; then
		elog "Gerbera has been built with MySQL support and needs"
		elog "to be configured before being started. By default"
		elog "SQLite will be used."
	fi
}
