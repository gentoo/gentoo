# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# TODO: multiple ABI?
PYTHON_COMPAT=( python2_7 )
inherit eutils flag-o-matic cmake-utils python-single-r1

DESCRIPTION="Crazy Eddie's GUI System"
HOMEPAGE="http://www.cegui.org.uk/"
SRC_URI="mirror://sourceforge/crayzedsgui/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bidi debug devil doc freeimage expat irrlicht lua ogre opengl pcre python static-libs tinyxml truetype xerces-c +xml zip"
REQUIRED_USE="|| ( expat tinyxml xerces-c xml )
	${PYTHON_REQUIRED_USE}" # bug 362223

# gles broken
#	gles? ( media-libs/mesa[gles1] )
# directfb broken
#	directfb? ( dev-libs/DirectFB )
RDEPEND="
	dev-libs/boost:=
	virtual/libiconv
	bidi? ( dev-libs/fribidi )
	devil? ( media-libs/devil )
	expat? ( dev-libs/expat )
	freeimage? ( media-libs/freeimage )
	irrlicht? ( dev-games/irrlicht )
	lua? (
		dev-lang/lua:0
		dev-lua/toluapp
	)
	ogre? ( >=dev-games/ogre-1.7:= )
	opengl? (
		virtual/opengl
		virtual/glu
		media-libs/glew:=
	)
	pcre? ( dev-libs/libpcre )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)
	tinyxml? ( dev-libs/tinyxml )
	truetype? ( media-libs/freetype:2 )
	xerces-c? ( dev-libs/xerces-c )
	xml? ( dev-libs/libxml2 )
	zip? ( sys-libs/zlib[minizip] )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	opengl? ( media-libs/glm )"

PATCHES=( "${FILESDIR}"/${P}-icu-59.patch )

src_configure() {
	# http://www.cegui.org.uk/mantis/view.php?id=991
	append-ldflags $(no-as-needed)

	local mycmakeargs=(
		-DCEGUI_BUILD_IMAGECODEC_CORONA=OFF
		$(cmake-utils_use devil CEGUI_BUILD_IMAGECODEC_DEVIL)
		$(cmake-utils_use freeimage CEGUI_BUILD_IMAGECODEC_FREEIMAGE)
		-DCEGUI_BUILD_IMAGECODEC_PVR=OFF
		-DCEGUI_BUILD_IMAGECODEC_SILLY=OFF
		-DCEGUI_BUILD_IMAGECODEC_STB=ON
		-DCEGUI_BUILD_IMAGECODEC_TGA=ON
		$(cmake-utils_use lua CEGUI_BUILD_LUA_GENERATOR)
		$(cmake-utils_use lua CEGUI_BUILD_LUA_MODULE)
		$(cmake-utils_use python CEGUI_BUILD_PYTHON_MODULES)
		-DCEGUI_BUILD_RENDERER_DIRECTFB=OFF
		$(cmake-utils_use irrlicht CEGUI_BUILD_RENDERER_IRRLICHT)
		-DCEGUI_BUILD_RENDERER_NULL=ON
		$(cmake-utils_use ogre CEGUI_BUILD_RENDERER_OGRE)
		$(cmake-utils_use opengl CEGUI_BUILD_RENDERER_OPENGL)
		$(cmake-utils_use opengl CEGUI_BUILD_RENDERER_OPENGL3)
		-DCEGUI_BUILD_RENDERER_OPENGLES=OFF
		$(cmake-utils_use static-libs CEGUI_BUILD_STATIC_CONFIGURATION)
		-DCEGUI_BUILD_TESTS=OFF
		$(cmake-utils_use expat CEGUI_BUILD_XMLPARSER_EXPAT)
		$(cmake-utils_use xml CEGUI_BUILD_XMLPARSER_LIBXML2)
		-DCEGUI_BUILD_XMLPARSER_RAPIDXML=OFF
		$(cmake-utils_use tinyxml CEGUI_BUILD_XMLPARSER_TINYXML)
		$(cmake-utils_use xerces-c CEGUI_BUILD_XMLPARSER_XERCES)
		$(cmake-utils_use truetype CEGUI_HAS_FREETYPE)
		$(cmake-utils_use zip CEGUI_HAS_MINIZIP_RESOURCE_PROVIDER)
		$(cmake-utils_use pcre CEGUI_HAS_PCRE_REGEX)
		-DCEGUI_SAMPLES_ENABLED=OFF
		$(cmake-utils_use bidi CEGUI_USE_FRIBIDI)
		-DCEGUI_USE_MINIBIDI=OFF
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && emake -C "${BUILD_DIR}" html
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml "${BUILD_DIR}"/doc/doxygen/html/*
}
