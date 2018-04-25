# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils mercurial

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="http://www.ogre3d.org/"

EHG_REPO_URI="https://bitbucket.org/sinbad/ogre"
EHG_REVISION="2610e3b582ac2486ce2792e2ce5e37ff2dd78808"
SRC_URI=""

LICENSE="MIT public-domain"
SLOT="0/2.1"
KEYWORDS=""

IUSE="doc debug examples +freeimage gl3plus gles2 gles3 json ois +opengl profile tools"

# USE flags for features that do not work, yet
# cg double-precision

REQUIRED_USE="examples? ( ois )
	gles3? ( gles2 )
	gl3plus? ( opengl )"

RESTRICT="test" #139905

RDEPEND="
	dev-libs/zziplib
	freeimage? ( media-libs/freeimage )
	gl3plus? ( >=media-libs/mesa-9.2.5 )
	gles2? ( >=media-libs/mesa-9.0.0[gles2] )
	gles3? ( >=media-libs/mesa-10.0.0[gles2] )
	json? ( dev-libs/rapidjson )
	media-libs/freetype:2
	ois? ( dev-games/ois )
	tools? ( dev-libs/tinyxml[stl] )
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXrandr
	x11-libs/libXt"
# Dependencies for USE flags that do not work, yet.
#	cg? ( media-gfx/nvidia-cg-toolkit )
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	x11-proto/xf86vidmodeproto"
PATCHES=(
	"${FILESDIR}/${P}-samples.patch"
	"${FILESDIR}/${P}-resource_path.patch"
	"${FILESDIR}/${P}-media_path.patch"
)

src_unpack() {
	mercurial_src_unpack
}

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
		-DOGRE_BUILD_COMPONENT_HLMS_PBS_MOBILE=NO
		-DOGRE_BUILD_COMPONENT_HLMS_UNLIT_MOBILE=NO
		-DOGRE_BUILD_SAMPLES2=$(usex examples)
		-DOGRE_BUILD_TESTS=NO
		-DOGRE_BUILD_TOOLS=$(usex tools)
		-DOGRE_CONFIG_ENABLE_FREEIMAGE=$(usex freeimage)
		-DOGRE_CONFIG_THREADS=2
		-DOGRE_CONFIG_THREAD_PROVIDER=std
		-DOGRE_FULL_RPATH=NO
		-DOGRE_INSTALL_DOCS=$(usex doc)
		-DOGRE_INSTALL_SAMPLES=$(usex examples)
		-DOGRE_INSTALL_SAMPLES_SOURCE=$(usex examples)
		-DOGRE_PROFILING_PROVIDER=$(usex profile none internal)
		-DOGRE_USE_BOOST=NO
	)
	# USE flags for features that do not work, yet
	#	-DOGRE_BUILD_PLUGIN_CG=$(usex cg)
	#	-DOGRE_CONFIG_DOUBLE=$(usex double-precision)
	# These components are off by default, as they might not be ported, yet.
	# When advancing to a newer commit, try whether any of the disabled
	# components can be activated now.
	mycmakeargs+=(
		-DOGRE_BUILD_COMPONENT_PAGING=NO
		-DOGRE_BUILD_COMPONENT_PLANAR_REFLECTIONS=YES
		-DOGRE_BUILD_COMPONENT_PROPERTY=NO
		-DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM=NO
		-DOGRE_BUILD_COMPONENT_TERRAIN=NO
		-DOGRE_BUILD_COMPONENT_VOLUME=NO
	)

	# Ogre3D is making use of "CMAKE_INSTALL_CONFIG_NAME MATCHES ..." and
	# sets it to BUILD_TYPE. Only RelWithDebInfo, MinSizeRel and Debug
	# are supported.
	CMAKE_BUILD_TYPE="$(usex debug Debug RelWithDebInfo)"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	CONFIGDIR=/etc/OGRE
	SHAREDIR=/usr/share/OGRE

	# plugins and resources are the main configuration
	insinto "${CONFIGDIR}"
	doins "${CMAKE_BUILD_DIR}"/bin/plugins.cfg
	doins "${CMAKE_BUILD_DIR}"/bin/plugins_tools.cfg
	doins "${CMAKE_BUILD_DIR}"/bin/resources.cfg
	doins "${CMAKE_BUILD_DIR}"/bin/resources2.cfg
	dosym "${CONFIGDIR}"/plugins.cfg "${SHAREDIR}"/plugins.cfg
	dosym "${CONFIGDIR}"/plugins_tools.cfg "${SHAREDIR}"/plugins_tools.cfg
	dosym "${CONFIGDIR}"/resources.cfg "${SHAREDIR}"/resources.cfg
	dosym "${CONFIGDIR}"/resources2.cfg "${SHAREDIR}"/resources2.cfg

	# These are only for the Samples
	if use examples ; then
		insinto "${SHAREDIR}"
		doins "${CMAKE_BUILD_DIR}"/bin/samples.cfg
	fi
}
