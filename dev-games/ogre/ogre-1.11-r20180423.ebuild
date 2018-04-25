# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils mercurial

DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="http://www.ogre3d.org/"

EHG_REPO_URI="https://bitbucket.org/sinbad/ogre"
EHG_REVISION="a321ca311c7d87e664b37590a9c8f0b102475dc5"
SRC_URI=""

LICENSE="MIT public-domain"
SLOT="0/1.11"
KEYWORDS=""

IUSE="cg debug doc double-precision examples +freeimage gl3plus gles2 gles3 \
json ois openexr +opengl pch profile tools"

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
	openexr? ( media-libs/openexr )
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
	"${FILESDIR}/${P}-media_path.patch"
	"${FILESDIR}/${P}-OgreBites.patch"
	"${FILESDIR}/${P}-resource_path.patch"
	"${FILESDIR}/${P}-samples.patch"
	"${FILESDIR}/${P}-fix_sample_source_install.patch"
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
		-DOGRE_BUILD_COMPONENT_JAVA=NO
		-DOGRE_BUILD_COMPONENT_PAGING=YES
		-DOGRE_BUILD_COMPONENT_PROPERTY=YES
		-DOGRE_BUILD_COMPONENT_PYTHON=NO
		-DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM=YES
		-DOGRE_BUILD_COMPONENT_TERRAIN=YES
		-DOGRE_BUILD_COMPONENT_VOLUME=YES
		-DOGRE_BUILD_DEPENDENCIES=NO
		-DOGRE_BUILD_PLUGIN_CG=$(usex cg)
		-DOGRE_BUILD_PLUGIN_FREEIMAGE=$(usex freeimage)
		-DOGRE_BUILD_PLUGIN_EXRCODEC=$(usex openexr)
		-DOGRE_BUILD_SAMPLES=$(usex examples)
		-DOGRE_BUILD_TESTS=NO
		-DOGRE_BUILD_TOOLS=$(usex tools)
		-DOGRE_CONFIG_DOUBLE=$(usex double-precision)
		-DOGRE_CONFIG_THREADS=3
		-DOGRE_CONFIG_THREAD_PROVIDER=std
		-DOGRE_ENABLE_PRECOMPILED_HEADERS=$(usex pch)
		-DOGRE_FULL_RPATH=NO
		-DOGRE_INSTALL_DOCS=$(usex doc)
		-DOGRE_INSTALL_SAMPLES=$(usex examples)
		-DOGRE_INSTALL_SAMPLES_SOURCE=$(usex examples)
		-DOGRE_PROFILING=$(usex profile)
		-DOGRE_RESOURCEMANAGER_STRICT=2
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
	doins "${CMAKE_BUILD_DIR}"/bin/resources.cfg
	dosym "${CONFIGDIR}"/plugins.cfg "${SHAREDIR}"/plugins.cfg
	dosym "${CONFIGDIR}"/resources.cfg "${SHAREDIR}"/resources.cfg

	# Unfortunately make install forgets the samples.
	if use examples ; then
		# These are only for the sample browser
		insinto "${SHAREDIR}"
		doins "${CMAKE_BUILD_DIR}"/bin/quakemap.cfg
		doins "${CMAKE_BUILD_DIR}"/bin/samples.cfg
	fi
}
