# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Simple (yet powerful) news feed reader"
HOMEPAGE="https://github.com/martinrotter/rssguard/"
SRC_URI="
	https://github.com/martinrotter/rssguard/releases/download/${PV}/${P}-src.tar.gz
"

LICENSE="|| ( LGPL-3 GPL-2+ ) AGPL-3+ BSD GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="icu libmpv mysql qtmultimedia +sqlite"
REQUIRED_USE="
	|| ( mysql sqlite )
	?? ( libmpv qtmultimedia )
"

# go for article-extractor plugin
BDEPEND="
	dev-lang/go
	dev-qt/qttools:6[linguist]
"
DEPEND="
	dev-qt/qtbase:6[concurrent,dbus,gui,mysql?,network,sql,sqlite?,ssl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtmultimedia:6[gstreamer]
	media-libs/libglvnd
	virtual/zlib:=
	icu? ( dev-libs/icu:= )
	libmpv? (
		dev-qt/qtbase:6[opengl]
		media-video/mpv:=
	)
	qtmultimedia? (
		dev-qt/qtbase:6[opengl]
		dev-qt/qtmultimedia:6
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	# https://github.com/martinrotter/rssguard/pull/2031
	"${FILESDIR}/${P}-build.patch"
)

# go
QA_FLAGS_IGNORED="/usr/bin/rssguard-article-extractor"

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=ON
		-DREVISION_FROM_GIT=OFF
		-DNO_UPDATE_CHECK=ON
		-DENABLE_COMPRESSED_SITEMAP=ON
		-DENABLE_ICU=$(usex icu)
		-DENABLE_MEDIAPLAYER_QTMULTIMEDIA=$(usex qtmultimedia)
		-DENABLE_MEDIAPLAYER_LIBMPV=$(usex libmpv)
		# recommended
		-DMEDIAPLAYER_FORCE_OPENGL=ON
		# TODO: unbundle gumbo? unfortunately upstream is inlining it
		# into their CMakeLists rather than using litehtml CMakeLists
		# that support external gumbo
	)

	cmake_src_configure
}
