# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature xdg

DESCRIPTION="Simple (yet powerful) news feed reader"
HOMEPAGE="https://github.com/martinrotter/rssguard/"
SRC_URI="
	https://github.com/martinrotter/rssguard/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( LGPL-3 GPL-2+ ) AGPL-3+ BSD GPL-3+ MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="libmpv mysql qtmultimedia +sqlite webengine"
REQUIRED_USE="
	|| ( mysql sqlite )
	?? ( libmpv qtmultimedia )
"

BDEPEND="
	dev-qt/qttools:6[linguist]
"
DEPEND="
	dev-qt/qtbase:6[concurrent,dbus,gui,mysql?,network,sql,sqlite?,ssl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtmultimedia:6[gstreamer]
	dev-qt/qt5compat:6
	media-libs/libglvnd
	sys-libs/zlib:=
	libmpv? (
		dev-qt/qtbase:6[opengl]
		media-video/mpv:=
	)
	qtmultimedia? (
		dev-qt/qtbase:6[opengl]
		dev-qt/qtmultimedia:6
	)
	webengine? ( dev-qt/qtwebengine:6[widgets(+)] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	# https://github.com/martinrotter/rssguard/pull/1612
	"${FILESDIR}/${P}-qt-feature-checks.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=ON
		-DNO_LITE=$(usex webengine)
		-DREVISION_FROM_GIT=OFF
		-DNO_UPDATE_CHECK=ON
		-DENABLE_COMPRESSED_SITEMAP=ON
		-DENABLE_MEDIAPLAYER_QTMULTIMEDIA=$(usex qtmultimedia)
		-DENABLE_MEDIAPLAYER_LIBMPV=$(usex libmpv)
		# recommended
		-DMEDIAPLAYER_FORCE_OPENGL=ON
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "ad blocking functionality" "net-libs/nodejs[npm]"
}
