# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_REMOVE_MODULES_LIST="FindFreetype FindDoxygen FindZLIB"

inherit cmake flag-o-matic git-r3

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="https://www.ogre3d.org/"

EGIT_BRANCH="v2-1"
EGIT_COMMIT="5b682fb90c9e8e660e2fbf92bbf7797a9246700d"
EGIT_REPO_URI="https://github.com/OGRECave/ogre-next.git"
EGIT_SUBMODULES=()

LICENSE="MIT public-domain"
SLOT="0/2.1"
KEYWORDS="~amd64"

IUSE="+cache debug doc egl examples +freeimage gles2 json
	legacy-animations mobile +opengl profile tools"

# USE flags that do not work, as their options aren't ported, yet.
#      cg
#      double-precision

REQUIRED_USE="
	|| ( gles2 opengl )
	mobile? ( egl gles2 !opengl )"

RESTRICT="test" #139905

RDEPEND="
	dev-games/ois
	dev-libs/zziplib
	media-libs/freetype:2
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libXt
	egl? ( media-libs/mesa[egl] )
	freeimage? ( media-libs/freeimage )
	gles2? ( media-libs/mesa[gles2] )
	json? ( dev-libs/rapidjson )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	tools? ( dev-libs/tinyxml[stl] )
"
# Dependencies for USE flags that do not work, yet.
#	cg? ( media-gfx/nvidia-cg-toolkit )

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.1-samples.patch"
	"${FILESDIR}/${PN}-2.1-resource_path.patch"
	"${FILESDIR}/${PN}-2.1-media_path.patch"
	"${FILESDIR}/${PN}-2.1-enhance_config_loading.patch"
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
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOGRE_BUILD_COMPONENT_HLMS_PBS=$(         usex mobile no yes)
		-DOGRE_BUILD_COMPONENT_HLMS_PBS_MOBILE=$(  usex mobile)
		-DOGRE_BUILD_COMPONENT_HLMS_UNLIT=$(       usex mobile no yes)
		-DOGRE_BUILD_COMPONENT_HLMS_UNLIT_MOBILE=$(usex mobile)
		-DOGRE_BUILD_COMPONENT_PLANAR_REFLECTIONS=yes
		-DOGRE_BUILD_COMPONENT_SCENE_FORMAT=yes
		-DOGRE_BUILD_PLATFORM_NACL=no
		-DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=$(usex opengl)
		-DOGRE_BUILD_RENDERSYSTEM_GLES=no
		-DOGRE_BUILD_RENDERSYSTEM_GLES2=$(usex gles2)
		-DOGRE_BUILD_SAMPLES2=$(usex examples)
		-DOGRE_BUILD_TESTS=no
		-DOGRE_BUILD_TOOLS=$(usex tools)
		-DOGRE_CONFIG_ALLOCATOR=$(usex debug 5 1)
		-DOGRE_CONFIG_ENABLE_FINE_LIGHT_MASK_GRANULARITY=yes
		-DOGRE_CONFIG_ENABLE_FREEIMAGE=$(usex freeimage)
		-DOGRE_CONFIG_ENABLE_GL_STATE_CACHE_SUPPORT=$(usex cache)
		-DOGRE_CONFIG_ENABLE_GLES3_SUPPORT=$(\
			usex gles2 $(\
			usex mobile no yes) no)
		-DOGRE_CONFIG_ENABLE_JSON=$(usex json)
		-DOGRE_CONFIG_MEMTRACK_DEBUG=$(usex debug)
		-DOGRE_CONFIG_THREADS=2
		-DOGRE_CONFIG_THREAD_PROVIDER=std
		-DOGRE_FULL_RPATH=no
		-DOGRE_INSTALL_DOCS=$(usex doc)
		-DOGRE_INSTALL_SAMPLES=$(usex examples)
		-DOGRE_INSTALL_SAMPLES_SOURCE=$(usex examples)
		-DOGRE_LEGACY_ANIMATIONS=$(usex legacy-animations)
		-DOGRE_PROFILING_PROVIDER=$(usex profile none internal)
		-DOGRE_USE_BOOST=no
	)

	# The double-precision mode can not be enabled, yet.
	#	-DOGRE_CONFIG_DOUBLE=$(usex double-precision)

	# The CgFxScriptLoader doesn't seem to be completely ported, yet.
	# USE flag disabled.
	mycmakeargs+=(
		-DOGRE_BUILD_PLUGIN_CG=no
	)

	# These components are off by default, as they might not be ported, yet.
	# When advancing to a newer commit, try whether any of the disabled
	# components can be activated now.
	mycmakeargs+=(
		-DOGRE_BUILD_COMPONENT_PAGING=no
		-DOGRE_BUILD_COMPONENT_PROPERTY=no
		-DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM=no
		-DOGRE_BUILD_RTSHADERSYSTEM_CORE_SHADERS=no
		-DOGRE_BUILD_RTSHADERSYSTEM_EXT_SHADERS=no
		-DOGRE_BUILD_COMPONENT_TERRAIN=no
		-DOGRE_BUILD_COMPONENT_VOLUME=no
	)

	# Take out the warning about deprecated copy, as Ogre emits thousands of
	# those. But using a deprecated way of doing things isn't an error and
	# mainly of interest for developers.
	# (The warning is part of -Wextra and only effects C++ compilation.)
	append-cxxflags $(test-flags-CXX -Wno-deprecated-copy)

	# The same with the old ways of using memset(0...) on objects. It is
	# no longer assumed to be a good idea, but a warning about it isn't
	# of any value to the user. (And it happens many times in Ogre.)
	append-cxxflags $(test-flags-CXX -Wno-class-memaccess)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	CONFIGDIR=/etc/OGRE
	SHAREDIR=/usr/share/OGRE

	# plugins and resources are the main configuration
	insinto "${CONFIGDIR}"
	doins "${BUILD_DIR}"/bin/plugins.cfg
	doins "${BUILD_DIR}"/bin/plugins_tools.cfg
	doins "${BUILD_DIR}"/bin/resources.cfg
	doins "${BUILD_DIR}"/bin/resources2.cfg
	dosym "${CONFIGDIR}"/plugins.cfg "${SHAREDIR}"/plugins.cfg
	dosym "${CONFIGDIR}"/plugins_tools.cfg "${SHAREDIR}"/plugins_tools.cfg
	dosym "${CONFIGDIR}"/resources.cfg "${SHAREDIR}"/resources.cfg
	dosym "${CONFIGDIR}"/resources2.cfg "${SHAREDIR}"/resources2.cfg

	# These are only for the Samples
	if use examples ; then
		insinto "${SHAREDIR}"
		doins "${BUILD_DIR}"/bin/samples.cfg
	fi
}
