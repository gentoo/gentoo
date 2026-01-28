# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake readme.gentoo-r1 xdg-utils

MY_PN="OpenRCT2"
MY_PN_MSX="openmusic"
MY_PN_OBJ="objects"
MY_PN_RPL="replays"
MY_PN_SFX="opensound"
MY_PN_TS="title-sequences"
MY_PV_MSX="1.6.1"
MY_PV_OBJ="1.7.5"
MY_PV_RPL="0.0.92"
MY_PV_SFX="1.0.6"
MY_PV_TS="0.4.26"

DESCRIPTION="An open source re-implementation of Chris Sawyer's RollerCoaster Tycoon 2"
HOMEPAGE="https://openrct2.org/"
SRC_URI="
	https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/${MY_PN}/${MY_PN_MSX}/releases/download/v${MY_PV_MSX}/${MY_PN_MSX}.zip -> ${PN}-${MY_PN_MSX}-${MY_PV_MSX}.zip
	https://github.com/${MY_PN}/${MY_PN_OBJ}/releases/download/v${MY_PV_OBJ}/${MY_PN_OBJ}.zip -> ${PN}-${MY_PN_OBJ}-${MY_PV_OBJ}.zip
	https://github.com/${MY_PN}/OpenSoundEffects/releases/download/v${MY_PV_SFX}/${MY_PN_SFX}.zip -> ${PN}-${MY_PN_SFX}-${MY_PV_SFX}.zip
	https://github.com/${MY_PN}/${MY_PN_TS}/releases/download/v${MY_PV_TS}/${MY_PN_TS}.zip -> ${PN}-${MY_PN_TS}-${MY_PV_TS}.zip
	test? ( https://github.com/${MY_PN}/${MY_PN_RPL}/releases/download/v${MY_PV_RPL}/${MY_PN_RPL}.zip -> ${PN}-${MY_PN_RPL}-${MY_PV_RPL}.zip )
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="dedicated +flac +opengl scripting test +truetype +vorbis"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/icu:=
	dev-libs/jansson:=
	dev-libs/libzip:=
	media-libs/libpng:=
	net-misc/curl[ssl]
	virtual/zlib:=
	!dedicated? (
		media-libs/libsdl2
		media-libs/speexdsp
		flac? ( media-libs/flac:= )
		opengl? ( virtual/opengl )
		vorbis? ( media-libs/libvorbis )
	)
	dev-libs/openssl:0=
	scripting? ( dev-lang/duktape:= )
	truetype? (
		media-libs/fontconfig:1.0
		media-libs/freetype:2
	)
"

RDEPEND="
	${COMMON_DEPEND}
	dedicated? (
		acct-group/openrct2
		acct-user/openrct2
	)
"

DEPEND="
	${COMMON_DEPEND}
	dev-cpp/nlohmann_json
	test? ( dev-cpp/gtest )
"

BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-0.4.1-gtest-1.10.patch"
	"${FILESDIR}/${PN}-0.4.16-include-additional-paths.patch"
)

src_unpack() {
	unpack "${P}".tar.gz

	mkdir -p "${S}"/data || die
	cd "${S}"/data
	unpack "${PN}-${MY_PN_MSX}-${MY_PV_MSX}".zip
	unpack "${PN}-${MY_PN_SFX}-${MY_PV_SFX}".zip

	mkdir -p "${S}"/data/object || die
	cd "${S}"/data/object || die
	unpack "${PN}-${MY_PN_OBJ}-${MY_PV_OBJ}".zip

	mkdir -p "${S}"/data/sequence || die
	cd "${S}"/data/sequence || die
	unpack "${PN}-${MY_PN_TS}-${MY_PV_TS}".zip

	if use test; then
		mkdir -p "${S}"/testdata/replays || die
		cd "${S}"/testdata/replays || die
		unpack "${PN}-${MY_PN_RPL}-${MY_PV_RPL}".zip
	fi
}

src_prepare() {
	cmake_src_prepare

	# Don't treat warnings as errors.
	sed -e 's/-Werror//' -i CMakeLists.txt || die
}

src_configure() {
	# Note: There is currently no support for Disord-RPC and Google Benchmark,
	# as both packages do not exist in Gentoo, so support for them has been disabled.
	local mycmakeargs=(
		-DDISABLE_DISCORD_RPC=ON
		$(usex !dedicated "-DDISABLE_FLAC=$(usex !flac)" "")
		-DDISABLE_GOOGLE_BENCHMARK=ON
		-DDISABLE_GUI=$(usex dedicated)
		-DDISABLE_HTTP=OFF
		-DDISABLE_IPO=ON
		-DDISABLE_NETWORK=OFF
		$(usex !dedicated "-DDISABLE_OPENGL=$(usex !opengl)" "")
		-DDISABLE_TTF=$(usex !truetype)
		$(usex !dedicated "-DDISABLE_VORBIS=$(usex !vorbis)" "")
		-DDOWNLOAD_OBJECTS=OFF
		-DDOWNLOAD_OPENMSX=OFF
		-DDOWNLOAD_OPENSFX=OFF
		-DDOWNLOAD_REPLAYS=OFF
		-DDOWNLOAD_TITLE_SEQUENCES=OFF
		-DENABLE_SCRIPTING="$(usex scripting)"
		-DOPENRCT2_USE_CCACHE=OFF
		-DPORTABLE=OFF
		-DSTATIC=OFF
		-DWITH_TESTS="$(usex test)"
		-DUSE_MMAP=ON
	)

	cmake_src_configure
}

src_test() {
	# Since the tests need the OpenRCT2 data,
	# we need to symlink them into the build directory,
	# otherwise some tests will fail, as they don't find the OpenRCT2 data.
	# It is currently not possible to override that path.
	# See: https://github.com/OpenRCT2/OpenRCT2/issues/6473
	ln -s "${S}"/data "${BUILD_DIR}" || die

	cmake_src_test
}

src_install() {
	use scripting && DOCS+=( "distribution/scripting.md" "distribution/openrct2.d.ts" )

	cmake_src_install

	if use dedicated; then
		newinitd "${FILESDIR}"/openrct2.initd openrct2
		newconfd "${FILESDIR}"/openrct2.confd openrct2
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
