# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="ar_SA bg_BG ca_ES cs da de el en_GB eo es et_EE fa_IR fi fr fy ga he_IL hr hu id it ja_JP ko la lt my_MM nb nl pl pt pt_BR ro ru sk sl tr tt_RU uk_UA zh_CN zh_TW"
inherit branding cmake flag-o-matic plocale xdg

MY_PV=$(ver_cut 1-2)
VIDEOS_PV=2.2
VIDEOS_P=${PN}-videos-${VIDEOS_PV}.wz

DESCRIPTION="3D real-time strategy game"
HOMEPAGE="https://wz2100.net/"
SRC_URI="
	https://downloads.sourceforge.net/warzone2100/releases/${PV}/${PN}_src.tar.xz -> ${P}.tar.xz
	videos? ( https://downloads.sourceforge.net/warzone2100/warzone2100/Videos/${VIDEOS_PV}/high-quality-en/sequences.wz -> ${VIDEOS_P} )
"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+ CC-BY-SA-3.0 public-domain vulkan? ( GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
# Upstream requested debug support
IUSE="debug discord nls videos vulkan"

COMMON_DEPEND="
	dev-libs/fribidi
	>=dev-games/physfs-2[zip]
	dev-db/sqlite:3
	>=dev-libs/libsodium-1.0.14:=
	dev-libs/libzip:=
	>=dev-libs/protobuf-2.6.1:=
	media-libs/freetype:2
	media-libs/harfbuzz:=
	media-libs/libjpeg-turbo
	media-libs/libogg
	media-libs/libpng:=
	>=media-libs/libsdl3-3.2.12[opengl,X]
	media-libs/libtheora:=
	media-libs/libvorbis
	media-libs/openal
	media-libs/opus
	media-libs/opusfile
	net-libs/miniupnpc:=
	net-misc/curl
	virtual/zlib:=
	nls? ( virtual/libintl )
	vulkan? ( media-libs/libsdl3[vulkan] )
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/date
	media-libs/fontconfig
"
RDEPEND="
	${COMMON_DEPEND}
	media-fonts/dejavu
"
BDEPEND="
	app-arch/zip
	app-text/asciidoc
	games-util/basis_universal
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

HTML_DOCS=( doc/quickstartguide.html doc/docbook-xsl.css doc/ScriptingManual.htm )
DOCS=( README.md doc/images doc/Scripting.md doc/js-globals.md )

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.1-clang-fmt-stdlib-include.patch
	"${FILESDIR}"/${PN}-4.7.0-vulkan.patch
	"${FILESDIR}"/${PN}-4.7.0-c++20.patch
)

src_unpack() {
	unpack ${P}.tar.xz
}

src_prepare() {
	sed -i -e 's/#top_builddir/top_builddir/' po/Makevars || die

	# Delete translations we're not using
	cleanup_po() {
		local locale=${1}
		einfo "Cleaning up disabled locale: ${locale}"
		rm po/${locale}.po || die
	}

	plocale_for_each_disabled_locale cleanup_po

	# Unbundle date (which also fixes build w/ C++20)
	cp "${ESYSROOT}"/usr/include/date/date.h 3rdparty/date/ || die

	# Overridden in src_configure
	sed -i -e '/set.*CMAKE_CXX_STANDARD/d' CMakeLists.txt || die

	sed -i -e 's:cxx_std_17:cxx_std_20:' \
		3rdparty/GameNetworkingSockets/src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# ODR violations (bison, yy_*, bug #859268)
	filter-lto

	# bug #976363
	append-cxxflags -std=gnu++20

	# TODO: unbundle dev-cpp/nlohmann_json
	# TODO: unbundle dev-libs/libfmt
	# TODO: unbundle SQLiteCpp
	# TODO: unbundle dev-libs/inih
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD="20"

		-DWZ_DISTRIBUTOR="${BRANDING_OS_PRETTY_NAME}"
		-DWZ_ENABLE_WARNINGS_AS_ERRORS=OFF
		-DWZ_ENABLE_BACKEND_VULKAN=$(usex vulkan)
		-DWZ_SKIP_ELF_SEPARATE_DEBUG=ON
		-DWZ_USE_SYSTEM_LIBJPEG_TURBO=ON
		-DBUILD_SHARED_LIBS=OFF
		-DENABLE_NLS=$(usex nls)
		-DENABLE_DISCORD=$(usex discord)

		-DFMT_INSTALL=OFF
		-DSQLITECPP_INSTALL=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	asciidoc -b html5 doc/quickstartguide.asciidoc || die
}

src_install() {
	cmake_src_install

	# We cover licencing within the ebuild itself
	rm "${ED}"/usr/share/doc/${PF}/COPYING* \
		"${ED}"/usr/share/doc/${PF}/copyright || die

	docompress -x /usr/share/man/man6/warzone2100.6.gz

	if use videos ; then
		insinto /usr/share/${PN}
		newins "${DISTDIR}"/${VIDEOS_P} sequences.wz
	fi
}
