# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="A free, open source, cross-platform video editor"
HOMEPAGE="https://www.shotcut.org/ https://github.com/mltframework/shotcut/"
if [[ ${PV} != 9999* ]] ; then
	SRC_URI="https://github.com/mltframework/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mltframework/shotcut/"
fi

IUSE="debug"

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	dev-qt/linguist-tools:5
"
COMMON_DEPEND="
	dev-qt/qtdeclarative:5[widgets]
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsql:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=media-libs/mlt-7.8.0[ffmpeg,frei0r,fftw(+),jack,opengl,qt5,sdl,xml]
	media-video/ffmpeg
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/qtx11extras:5
"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtgraphicaleffects:5
	virtual/jack
"

src_configure() {
	CMAKE_BUILD_TYPE=$(usex debug Debug Release)
	local mycmakeargs=(
		-DSHOTCUT_VERSION="${PV}"
	)
	use debug || append-cxxflags "-DNDEBUG"
	append-cxxflags "-DSHOTCUT_NOUPGRADE"
	cmake_src_configure
}
