# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_REMOVE_MODULES="yes"
CMAKE_REMOVE_MODULES_LIST="FindFreetype FindDoxygen FindZLIB"
inherit cmake-utils

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="https://www.ogre3d.org/"
SRC_URI="https://github.com/OGRECave/${PN}/archive/v${PV}.zip -> ${P}.zip"

LICENSE="MIT public-domain"
SLOT="0/1.10.0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="+cache cg doc double-precision egl examples experimental +freeimage gles2
	+opengl profile resman-pedantic resman-strict tools"

REQUIRED_USE="
	|| ( gles2 opengl )
	?? ( resman-pedantic resman-strict )
	examples? ( experimental )
"
RESTRICT="test" #139905

RDEPEND="
	dev-games/ois
	dev-libs/boost:=
	dev-libs/zziplib
	media-libs/freetype:2
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libXt
	cg? ( media-gfx/nvidia-cg-toolkit )
	egl? ( media-libs/mesa[egl] )
	freeimage? ( media-libs/freeimage )
	gles2? ( media-libs/mesa[gles2] )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	tools? ( dev-libs/tinyxml[stl] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-1.10.11-samples.patch"
	"${FILESDIR}/${PN}-1.10.11-resource_path.patch"
	"${FILESDIR}/${PN}-1.10.11-media_path.patch"
	"${FILESDIR}/${P}-use_system_tinyxml.patch"
)

src_prepare() {
	sed -i \
		-e "s:share/OGRE/docs:share/doc/${PF}:" \
		Docs/CMakeLists.txt || die
	# Stupid build system hardcodes release names
	sed -i \
		-e '/CONFIGURATIONS/s:CONFIGURATIONS Release.*::' \
		CMake/Utils/OgreConfigTargets.cmake || die

	# Fix some path issues
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOGRE_BUILD_COMPONENT_BITES=$(usex experimental)
		-DOGRE_BUILD_COMPONENT_HLMS=$(usex experimental)
		-DOGRE_BUILD_COMPONENT_JAVA=no
		-DOGRE_BUILD_COMPONENT_PYTHON=no
		-DOGRE_BUILD_DEPENDENCIES=no
		-DOGRE_BUILD_PLUGIN_CG=$(usex cg)
		-DOGRE_BUILD_RENDERSYSTEM_GL=$(usex opengl)
		-DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=$(usex opengl)
		-DOGRE_BUILD_RENDERSYSTEM_GLES2=$(usex gles2)
		-DOGRE_BUILD_SAMPLES=$(usex examples)
		-DOGRE_BUILD_TESTS=no
		-DOGRE_BUILD_TOOLS=$(usex tools)
		-DOGRE_CONFIG_DOUBLE=$(usex double-precision)
		-DOGRE_CONFIG_ENABLE_FREEIMAGE=$(usex freeimage)
		-DOGRE_CONFIG_ENABLE_GL_STATE_CACHE_SUPPORT=$(usex cache)
		-DOGRE_CONFIG_THREADS=3
		-DOGRE_CONFIG_THREAD_PROVIDER=std
		-DOGRE_FULL_RPATH=no
		-DOGRE_GLSUPPORT_USE_EGL=$(usex egl)
		-DOGRE_INSTALL_DOCS=$(usex doc)
		-DOGRE_INSTALL_SAMPLES=$(usex examples)
		-DOGRE_INSTALL_SAMPLES_SOURCE=$(usex examples)
		-DOGRE_NODE_STORAGE_LEGACY=no
		-DOGRE_PROFILING=$(usex profile)
		-DOGRE_RESOURCEMANAGER_STRICT=$(\
			usex resman-pedantic 1 $(\
			usex resman-strict 2 0))
		-DOGRE_USE_STD11=yes
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	CONFIGDIR=/etc/OGRE
	SHAREDIR=/usr/share/OGRE

	# plugins and resources are the main configuration
	insinto "${CONFIGDIR}"
	doins "${CMAKE_BUILD_DIR}"/bin/plugins.cfg
	doins "${CMAKE_BUILD_DIR}"/bin/resources.cfg
	dosym "${CONFIGDIR}"/plugins.cfg "${SHAREDIR}"/plugins.cfg
	dosym "${CONFIGDIR}"/resources.cfg "${SHAREDIR}"/resources.cfg

	# These are only for the sample browser
	insinto "${SHAREDIR}"
	doins "${CMAKE_BUILD_DIR}"/bin/quakemap.cfg
	doins "${CMAKE_BUILD_DIR}"/bin/samples.cfg
}
