# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="An open source re-implementation of RollerCoaster Tycoon 2"
HOMEPAGE="https://openrct2.org/"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/OpenRCT2/OpenRCT2.git"
	EGIT_BRANCH="develop"
	inherit git-r3
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/OpenRCT2/OpenRCT2/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/OpenRCT2-${PV}"
fi

TSV="0.1.2"
OBJV="1.0.3"
SRC_URI+="
	https://github.com/OpenRCT2/title-sequences/releases/download/v${TSV}/title-sequence-v${TSV}.zip
		-> ${PN}-title-sequence-v${TSV}.zip
	https://github.com/OpenRCT2/objects/releases/download/v${OBJV}/objects.zip
		-> ${PN}-objects-v${OBJV}.zip"

LICENSE="GPL-3"
SLOT="0"
IUSE="libressl +multiplayer opengl test truetype +twitch"

RDEPEND="
	>=dev-libs/jansson-2.5
	>=dev-libs/libzip-1.0
	media-libs/libpng:0=
	media-libs/libsdl2
	media-libs/speexdsp
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
	app-arch/unzip
	test? ( dev-cpp/gtest )
"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
	fi

	mkdir -p "${S}/data/title" || die
	pushd "${S}/data/title" || die
	unpack ${PN}-title-sequence-v${TSV}.zip
	popd || die

	mkdir -p "${S}/data/object" || die
	pushd "${S}/data/object" || die
	unpack ${PN}-objects-v${OBJV}.zip
	popd || die
}

src_prepare() {
	sed -i CMakeLists.txt -e 's/-Werror//' || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_HTTP_TWITCH="$(usex !twitch)"
		-DDISABLE_NETWORK="$(usex !multiplayer)"
		-DDISABLE_OPENGL="$(usex !opengl)"
		-DDISABLE_TTF="$(usex !truetype)"
		-DWITH_TESTS="$(usex test)"
		-DDOWNLOAD_TITLE_SEQUENCES=OFF
		-DDOWNLOAD_OBJECTS=OFF
		-DBUILD_SHARED_LIBS=ON
	)
	use test && mycmakeargs+=( -DSYSTEM_GTEST=ON )

	cmake-utils_src_configure
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		ewarn ""
		ewarn "You need the original RollerCoaster Tycoon 2 files to play this game."
		ewarn "See: https://github.com/OpenRCT2/OpenRCT2/wiki/Required-RCT2-files#how-to-retrieve"
		ewarn ""
	fi
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
