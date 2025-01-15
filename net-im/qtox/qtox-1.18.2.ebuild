# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TokTok/qTox.git"
else
	MY_P="qTox-${PV}"
	SRC_URI="https://github.com/TokTok/qTox/archive/v${PV}/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/qTox-${PV}"
fi

DESCRIPTION="Instant messaging client using the encrypted p2p Tox protocol"
HOMEPAGE="https://qtox.github.io/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="spellcheck X"

BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"
RDEPEND="
	dev-db/sqlcipher
	dev-libs/libsodium:=
	dev-qt/qtbase:6[concurrent,gui,network,opengl,widgets,xml]
	dev-qt/qtsvg:6
	media-gfx/qrencode:=
	media-libs/libexif
	media-libs/openal
	media-video/ffmpeg:=[webp,v4l]
	>=net-libs/tox-0.2.19:=[av]
	spellcheck? (
		|| (
			kde-frameworks/sonnet:6[aspell]
			kde-frameworks/sonnet:6[hunspell]
		)
	)
	X? (
		dev-qt/qtbase:6=[X]
		x11-libs/libX11
		x11-libs/libXScrnSaver
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"

DOCS=( CHANGELOG.md README.md doc/user_manual_en.md )

src_configure() {
	local mycmakeargs=(
		-DASAN=OFF
		-DPLATFORM_EXTENSIONS=$(usex X)
		-DSPELL_CHECK=$(usex spellcheck)
		-DSTRICT_OPTIONS=OFF
		-DSVGZ_ICON=ON
		-DTSAN=OFF
		-DUBSAN=ON
		-DUPDATE_CHECK=OFF
		-DUSE_CCACHE=OFF
	)

	[[ ${PV} != 9999 ]] && mycmakeargs+=( -DGIT_DESCRIBE=${PV} )

	cmake_src_configure
}

src_test() {
	# The excluded tests require network access.
	cmake_src_test -E "test_(bsu|core)"
}
