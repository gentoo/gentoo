# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

MY_PV=$(ver_cut 1-2)
VIDEOS_PV=2.2
VIDEOS_P=${PN}-videos-${VIDEOS_PV}.wz
DESCRIPTION="3D real-time strategy game"
HOMEPAGE="https://wz2100.net/"
SRC_URI="mirror://sourceforge/warzone2100/releases/${PV}/${PN}_src.tar.xz -> ${P}.tar.xz
	videos? ( mirror://sourceforge/warzone2100/warzone2100/Videos/${VIDEOS_PV}/high-quality-en/sequences.wz -> ${VIDEOS_P} )"

LICENSE="GPL-2+ CC-BY-SA-3.0 public-domain"
SLOT="0"
#[[ "${PV}" == *_beta* ]] || \
KEYWORDS="~amd64 ~x86"
# upstream requested debug support
IUSE="debug discord nls videos vulkan"

# TODO: unbundle miniupnpc and quesoglc
# quesoglc-0.7.2 is buggy: http://developer.wz2100.net/ticket/2828
CDEPEND="
	>=dev-games/physfs-2[zip]
	>=dev-libs/libsodium-1.0.14
	dev-libs/openssl:0=
	media-libs/freetype:2
	media-libs/glew:=
	media-libs/harfbuzz
	media-libs/libogg
	media-libs/libpng:0
	media-libs/libsdl2[opengl,video,X]
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXrandr
	nls? ( virtual/libintl )
	vulkan? ( media-libs/libsdl2:=[vulkan] )
"
DEPEND="
	${CDEPEND}
	app-text/asciidoc
	dev-libs/fribidi
	media-libs/fontconfig
"
RDEPEND="
	${CDEPEND}
	media-fonts/dejavu
"
BDEPEND="
	app-arch/zip
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${P}.tar.xz
}

src_prepare() {
	default

	sed -i -e 's/#top_builddir/top_builddir/' po/Makevars || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWZ_DISTRIBUTOR="Gentoo"
		-DWZ_ENABLE_WARNINGS_AS_ERRORS="OFF"
		-DWZ_ENABLE_BACKEND_VULKAN="$(usex vulkan)"
		-DWZ_PORTABLE="OFF"
		-DBUILD_SHARED_LIBS="OFF"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_DISCORD="$(usex discord)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	asciidoc -b html5 doc/quickstartguide.asciidoc || die
}

src_install() {
	local HTML_DOCS=( doc/quickstartguide.html doc/docbook-xsl.css doc/ScriptingManual.htm )
	local DOCS=( README.md doc/images doc/Scripting.md doc/js-globals.md )
	default

	insinto /usr/bin
	dobin "${BUILD_DIR}"/src/${PN}

	insinto /usr/share/${PN}
	doins "${BUILD_DIR}"/data/base.wz
	doins "${BUILD_DIR}"/data/mp.wz
	if use videos ; then
		newins "${DISTDIR}"/${VIDEOS_P} sequences.wz
	fi
	insinto /usr/share/${PN}
	doins -r data/music

	doman "${BUILD_DIR}"/doc/warzone2100.6

	doicon -s 128 icons/warzone2100.png
	domenu icons/warzone2100.desktop
}
