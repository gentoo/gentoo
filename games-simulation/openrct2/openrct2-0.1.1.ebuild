# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="An open source re-implementation of RollerCoaster Tycoon 2"
HOMEPAGE="https://openrct2.website/"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/OpenRCT2/OpenRCT2.git"
	EGIT_BRANCH="develop"
	inherit git-r3
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/OpenRCT2/OpenRCT2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/OpenRCT2-${PV}"
fi

TSV="0.1.0"
SRC_URI+=" https://github.com/OpenRCT2/title-sequences/releases/download/v${TSV}/title-sequence-v${TSV}.zip -> ${PN}-title-sequence-v${TSV}.zip "

LICENSE="GPL-3"
SLOT="0"
IUSE="libressl +multiplayer opengl test truetype +twitch"

# This is needed because of this bug: https://github.com/OpenRCT2/OpenRCT2/issues/5469
REQUIRED_USE="multiplayer? ( twitch )"

RDEPEND="
	>=dev-libs/jansson-2.5
	>=dev-libs/libzip-1.0
	media-libs/libpng:0=
	media-libs/libsdl2
	|| (
		media-libs/speexdsp
		<media-libs/speex-1.2.0
	)
	multiplayer? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( dev-libs/openssl:0= )
	)
	opengl? ( virtual/opengl )
	truetype? (
		media-libs/sdl2-ttf
		media-libs/fontconfig
	)
	twitch? ( net-misc/curl[ssl] )
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

if [[ ${PV} == 9999 ]]; then
src_unpack() {
	default
	git-r3_src_unpack
}
fi

src_configure() {
	local mycmakeargs=(
		-DDISABLE_HTTP_TWITCH="$(usex !twitch)"
		-DDISABLE_NETWORK="$(usex !multiplayer)"
		-DDISABLE_OPENGL="$(usex !opengl)"
		-DDISABLE_TTF="$(usex !truetype)"
		-DWITH_TESTS="$(usex test)"
		-DDOWNLOAD_TITLE_SEQUENCES=OFF
		-DDISABLE_RCT2_TESTS=ON
		-DSYSTEM_GTEST=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/openrct2/title
	doins "${WORKDIR}"/*.parkseq
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		ewarn ""
		ewarn "You need the original RollerCoaster Tycoon 2 files to play this game."
		ewarn "See: https://github.com/OpenRCT2/OpenRCT2/wiki/Required-RCT2-files#how-to-retrieve"
		ewarn ""
	fi
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
