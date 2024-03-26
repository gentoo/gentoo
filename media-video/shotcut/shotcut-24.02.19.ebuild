# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="A free, open source, cross-platform video editor"
HOMEPAGE="https://www.shotcut.org/ https://github.com/mltframework/shotcut/"
if [[ ${PV} != 9999* ]] ; then
	SRC_URI="https://github.com/mltframework/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mltframework/shotcut/"
fi

IUSE="debug"

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	dev-qt/qttools:6[linguist]
"
DEPEND="
	dev-qt/qtbase:6[concurrent,gui,network,opengl,sql,widgets,xml]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtcharts:6
	>=media-libs/mlt-7.18.0[ffmpeg,frei0r,jack,opengl,sdl,xml]
	media-video/ffmpeg
"

RDEPEND="${DEPEND}
	virtual/jack
"

src_configure() {
	CMAKE_BUILD_TYPE=$(usex debug Debug Release)
	if [[ ${PV} != 9999* ]] ; then
		SHOTCUT_VERSION="${PV}"
	else
		SHOTCUT_VERSION="$(git log --date=format:'%y.%m.%d' -1 --format='%ad')"
	fi
	local mycmakeargs=(
		-DSHOTCUT_VERSION="${SHOTCUT_VERSION}"
	)
	use debug || append-cxxflags "-DNDEBUG"
	append-cxxflags "-DSHOTCUT_NOUPGRADE"
	cmake_src_configure
}
