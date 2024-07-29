# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/qTox/qTox.git"
else
	MY_P="qTox-${PV}"
	SRC_URI="https://github.com/qTox/qTox/releases/download/v${PV}/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="amd64 ~x86"
	S="${WORKDIR}/qTox"
fi

DESCRIPTION="Instant messaging client using the encrypted p2p Tox protocol"
HOMEPAGE="https://qtox.github.io/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+spellcheck test X"

RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	dev-db/sqlcipher
	dev-libs/libsodium:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[gif(+),jpeg,png,X(-)]
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/qrencode:=
	media-libs/libexif
	media-libs/openal
	media-video/ffmpeg:=[webp,v4l]
	>=net-libs/tox-0.2.13:=[av]
	spellcheck? ( kde-frameworks/sonnet:5 )
	X? (
		x11-libs/libX11
		x11-libs/libXScrnSaver
	)
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
	X? ( x11-base/xorg-proto )
"

DOCS=( CHANGELOG.md README.md doc/user_manual_en.md )

src_prepare() {
	cmake_src_prepare

	# bug 628574
	if ! use test; then
		sed -i CMakeLists.txt -e "/include(Testing)/d" || die
		sed -i cmake/Dependencies.cmake -e "/find_package(Qt5Test/d" || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DPLATFORM_EXTENSIONS=$(usex X)
		-DUPDATE_CHECK=OFF
		-DUSE_CCACHE=OFF
		-DSPELL_CHECK=$(usex spellcheck)
		-DSVGZ_ICON=ON
		-DASAN=OFF
		-DDESKTOP_NOTIFICATIONS=OFF
		-DSTRICT_OPTIONS=OFF
	)

	[[ ${PV} != 9999 ]] && mycmakeargs+=( -DGIT_DESCRIBE=${PV} )

	cmake_src_configure
}

src_test() {
	# The excluded tests require network access.
	cmake_src_test -E "test_(bsu|core)"
}
