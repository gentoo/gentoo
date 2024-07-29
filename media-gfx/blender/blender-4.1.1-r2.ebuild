# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
# matches media-libs/osl
LLVM_COMPAT=( {15..18} )

inherit check-reqs cmake cuda flag-o-matic llvm-r1 pax-utils python-single-r1 toolchain-funcs xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

if [[ ${PV} = *9999* ]] ; then
	EGIT_LFS="yes"
	inherit git-r3
	EGIT_REPO_URI="https://projects.blender.org/blender/blender.git"
	EGIT_SUBMODULES=( '*' '-lib/*' )
	ADDONS_EGIT_REPO_URI="https://projects.blender.org/blender/blender-addons.git"
	RESTRICT="!test? ( test )"
else
	SRC_URI="
		https://download.blender.org/source/${P}.tar.xz
	"
	# 	test? (
	# 		https://projects.blender.org/blender/blender-test-data/archive/blender-v$(ver_cut 1-2)-release.tar.gz
	# 	)
	# "
	KEYWORDS="amd64 ~arm ~arm64"
	RESTRICT="test" # the test archive returns LFS references.
fi

LICENSE="GPL-3+ cycles? ( Apache-2.0 )"
SLOT="${PV%.*}"
IUSE="
	alembic +bullet collada +color-management cuda +cycles +cycles-bin-kernels
	debug doc +embree experimental +ffmpeg +fftw +fluid +gmp gnome hip jack
	jemalloc jpeg2k man +nanovdb ndof nls +oidn oneapi openal +openexr +openmp openpgl
	+opensubdiv +openvdb optix osl +otf +pdf +potrace +pugixml pulseaudio
	renderdoc sdl +sndfile +tbb test +tiff valgrind vulkan wayland +webp X
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	alembic? ( openexr )
	cuda? ( cycles )
	cycles? ( openexr tiff tbb )
	fluid? ( tbb )
	gnome? ( wayland )
	hip? ( cycles )
	nanovdb? ( openvdb )
	openvdb? ( tbb openexr )
	optix? ( cuda )
	osl? ( cycles pugixml )
	test? ( color-management )"

# Library versions for official builds can be found in the blender source directory in:
# build_files/build_environment/cmake/versions.cmake
RDEPEND="${PYTHON_DEPS}
	app-arch/zstd
	dev-libs/boost:=[nls?]
	dev-libs/lzo:2=
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	media-libs/freetype:=[brotli]
	media-libs/libepoxy:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsamplerate
	>=media-libs/openimageio-2.5.6.0:=
	sys-libs/zlib:=
	virtual/glu
	virtual/libintl
	virtual/opengl
	alembic? ( >=media-gfx/alembic-1.8.3-r2[boost(+),hdf(+)] )
	collada? ( >=media-libs/opencollada-1.6.68 )
	color-management? ( media-libs/opencolorio:= )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	embree? ( media-libs/embree:=[raymask] )
	ffmpeg? ( media-video/ffmpeg:=[x264,mp3,encode,theora,jpeg2k?,vpx,vorbis,opus,xvid] )
	fftw? ( sci-libs/fftw:3.0= )
	gmp? ( dev-libs/gmp )
	gnome? ( gui-libs/libdecor )
	hip? (
		llvm_slot_17? (
			dev-util/hip:0/5.7
		)
		llvm_slot_18? (
			>=dev-util/hip-6.1:=[llvm_slot_18(-)]
		)
	)
	jack? ( virtual/jack )
	jemalloc? ( dev-libs/jemalloc:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	ndof? (
		app-misc/spacenavd
		dev-libs/libspnav
	)
	nls? ( virtual/libiconv )
	openal? ( media-libs/openal )
	oidn? ( >=media-libs/oidn-2.1.0 )
	oneapi? ( dev-libs/intel-compute-runtime[l0] )
	openexr? (
		>=dev-libs/imath-3.1.7:=
		>=media-libs/openexr-3.2.1:0=
	)
	openpgl? ( media-libs/openpgl:= )
	opensubdiv? ( >=media-libs/opensubdiv-3.5.0 )
	openvdb? (
		>=media-gfx/openvdb-11.0.0:=[nanovdb?]
		dev-libs/c-blosc:=
	)
	optix? ( dev-libs/optix )
	osl? (
		>=media-libs/osl-1.13:=[${LLVM_USEDEP}]
		media-libs/mesa[${LLVM_USEDEP}]
	)
	pdf? ( media-libs/libharu )
	potrace? ( media-gfx/potrace )
	pugixml? ( dev-libs/pugixml )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2[sound,joystick] )
	sndfile? ( media-libs/libsndfile )
	tbb? ( dev-cpp/tbb:= )
	tiff? ( media-libs/tiff:= )
	valgrind? ( dev-debug/valgrind )
	wayland? (
		>=dev-libs/wayland-1.12
		>=dev-libs/wayland-protocols-1.15
		>=x11-libs/libxkbcommon-0.2.0
		dev-util/wayland-scanner
		media-libs/mesa[wayland]
		sys-apps/dbus
	)
	vulkan? (
		media-libs/shaderc
		dev-util/spirv-tools
		dev-util/glslang
		media-libs/vulkan-loader
	)
	otf? (
		media-libs/harfbuzz
	)
	renderdoc? (
		media-gfx/renderdoc
	)
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
	)
"

DEPEND="${RDEPEND}
	dev-cpp/eigen:=
	vulkan? (
		dev-util/spirv-headers
		dev-util/vulkan-headers
	)
"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		dev-python/sphinx[latex]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? ( sys-devel/gettext )
	wayland? (
		dev-util/wayland-scanner
	)
	X? (
		x11-base/xorg-proto
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.2-FindClang.patch"
	"${FILESDIR}/${PN}-4.0.2-CUDA_NVCC_FLAGS.patch"
)

blender_check_requirements() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

blender_get_version() {
	# Get blender version from blender itself.
	BV=$(grep "BLENDER_VERSION " source/blender/blenkernel/BKE_blender_version.h | cut -d " " -f 3; assert)
	if ((${BV:0:1} < 3)) ; then
		# Add period (290 -> 2.90).
		BV=${BV:0:1}.${BV:1}
	else
		# Add period and skip the middle number (301 -> 3.1)
		BV=${BV:0:1}.${BV:2}
	fi
}

pkg_pretend() {
	blender_check_requirements

	if use oneapi; then
		einfo "The Intel oneAPI support is rudimentary."
		einfo ""
		einfo "Please report any bugs you find to https://bugs.gentoo.org/"
	fi
}

pkg_setup() {
	if use osl; then
		llvm-r1_pkg_setup
	fi

	blender_check_requirements
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} = *9999* ]] ; then
		if ! use test; then
			EGIT_SUBMODULES+=( '-tests/*' )
		fi
		git-r3_src_unpack

		git-r3_fetch "${ADDONS_EGIT_REPO_URI}"
		git-r3_checkout "${ADDONS_EGIT_REPO_URI}" "${S}/scripts/addons"
	else
		default

		if use test; then
			mkdir -p "${S}/tests/data/" || die
			mv blender-test-data/* "${S}/tests/data/" || die
		fi
	fi
}

src_prepare() {
	use cuda && cuda_src_prepare

	cmake_src_prepare

	blender_get_version

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
		-i doc/doxygen/Doxyfile || die

	# Prepare icons and .desktop files for slotting.
	sed \
		-e "s|blender.svg|blender-${BV}.svg|" \
		-e "s|blender-symbolic.svg|blender-${BV}-symbolic.svg|" \
		-e "s|blender.desktop|blender-${BV}.desktop|" \
		-e "s|org.blender.Blender.metainfo.xml|blender-${BV}.metainfo.xml|" \
		-i source/creator/CMakeLists.txt || die

	sed \
		-e "s|Name=Blender|Name=Blender ${BV}|" \
		-e "s|Exec=blender|Exec=blender-${BV}|" \
		-e "s|Icon=blender|Icon=blender-${BV}|" \
		-i release/freedesktop/blender.desktop || die

	sed -e "s|\${CMAKE_INSTALL_PREFIX}/\${BLENDER_BIN}|${T}/usr/\${BLENDER_BIN}|g" -i source/creator/CMakeLists.txt || die

	mv \
		release/freedesktop/icons/scalable/apps/blender.svg \
		"release/freedesktop/icons/scalable/apps/blender-${BV}.svg" || die
	mv \
		release/freedesktop/icons/symbolic/apps/blender-symbolic.svg \
		"release/freedesktop/icons/symbolic/apps/blender-${BV}-symbolic.svg" || die
	mv release/freedesktop/blender.desktop "release/freedesktop/blender-${BV}.desktop" || die
	mv release/freedesktop/org.blender.Blender.metainfo.xml "release/freedesktop/blender-${BV}.metainfo.xml"
	mv release/freedesktop/org.blender.Blender.appdata.xml "release/freedesktop/blender-${BV}.appdata.xml"

	if use test; then
		# Without this the tests will try to use /usr/bin/blender and /usr/share/blender/ to run the tests.
		sed -e "s|set(TEST_INSTALL_DIR.*|set(TEST_INSTALL_DIR ${T}/usr)|g" -i tests/CMakeLists.txt || die
		sed -e "s|string(REPLACE.*|set(TEST_INSTALL_DIR ${T}/usr)|g" -i build_files/cmake/testing.cmake || die
	fi

	if use vulkan; then
		sed -e "s/extern_vulkan_memory_allocator/extern_vulkan_memory_allocator\nSPIRV-Tools-opt\nSPIRV-Tools\nSPIRV-Tools-link\nglslang\nSPIRV\nSPVRemapper/" -i source/blender/gpu/CMakeLists.txt || die
	fi
}

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/859607
	# https://projects.blender.org/blender/blender/issues/120444
	filter-lto

	# Workaround for bug #922600
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	append-lfs-flags
	blender_get_version

	local mycmakeargs=(
		-DWITH_LIBS_PRECOMPILED=no
		-DBUILD_SHARED_LIBS=no
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DWITH_ALEMBIC=$(usex alembic)
		-DWITH_BOOST=yes
		-DWITH_BULLET=$(usex bullet)
		-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
		-DWITH_CODEC_SNDFILE=$(usex sndfile)

		-DWITH_CYCLES=$(usex cycles)

		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda)
		-DWITH_CYCLES_CUDA_BINARIES="$(usex cuda $(usex cycles-bin-kernels))"
		-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)

		-DWITH_CYCLES_DEVICE_HIP="$(usex hip)"
		-DWITH_CYCLES_HIP_BINARIES=$(usex hip $(usex cycles-bin-kernels))

		-DWITH_CYCLES_DEVICE_ONEAPI="$(usex oneapi)"
		-DWITH_CYCLES_ONEAPI_BINARIES="$(usex oneapi $(usex cycles-bin-kernels))"

		-DWITH_CYCLES_HYDRA_RENDER_DELEGATE="no" # TODO: package Hydra
		-DWITH_CYCLES_EMBREE="$(usex embree)"
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_CYCLES_PATH_GUIDING=$(usex openpgl)
		-DWITH_CYCLES_STANDALONE=no
		-DWITH_CYCLES_STANDALONE_GUI=no

		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_DRACO="no" # TODO: Package Draco
		-DWITH_EXPERIMENTAL_FEATURES="$(usex experimental)"
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_GHOST_WAYLAND=$(usex wayland)
		-DWITH_GHOST_WAYLAND_APP_ID="blender-${BV}"
		-DWITH_GHOST_WAYLAND_DYNLOAD="no"
		-DWITH_GHOST_WAYLAND_LIBDECOR="$(usex gnome)"
		-DWITH_GHOST_X11=$(usex X)
		-DWITH_GMP=$(usex gmp)
		-DWITH_GTESTS=$(usex test)
		-DWITH_HARFBUZZ="$(usex otf)"
		-DWITH_HARU=$(usex pdf)
		-DWITH_HEADLESS=$($(use X || use wayland) && echo OFF || echo ON)
		-DWITH_HYDRA="no" # TODO: Package Hydra
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_WEBP=$(usex webp)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INSTALL_PORTABLE="no"
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_MATERIALX="no" # TODO: Package MaterialX
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex fluid)
		-DWITH_MOD_OCEANSIM=$(usex fftw)
		-DWITH_NANOVDB=$(usex nanovdb)
		-DWITH_OPENAL=$(usex openal)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEDENOISE=$(usex oidn)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_POTRACE=$(usex potrace)
		-DWITH_PUGIXML=$(usex pugixml)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_PYTHON_INSTALL=no
		-DWITH_PYTHON_INSTALL_NUMPY=no
		-DWITH_PYTHON_INSTALL_ZSTANDARD=no
		-DWITH_RENDERDOC="$(usex renderdoc)"
		-DWITH_SDL=$(usex sdl)
		-DWITH_STATIC_LIBS=no
		-DWITH_STRICT_BUILD_OPTIONS=yes
		-DWITH_SYSTEM_EIGEN3=yes
		-DWITH_SYSTEM_FREETYPE=yes
		-DWITH_SYSTEM_LZO=yes
		-DWITH_TBB=$(usex tbb)
		-DWITH_USD="no" # TODO: Package USD
		-DWITH_VULKAN_BACKEND="$(usex vulkan)"
		-DWITH_XR_OPENXR=no
	)

	# requires dev-vcs/git
	if [[ ${PV} = *9999* ]] ; then
		mycmakeargs+=( -DWITH_BUILDINFO="yes" )
	else
		mycmakeargs+=( -DWITH_BUILDINFO="no" )
	fi

	if use cuda; then
		mycmakeargs+=(
			-DCUDA_NVCC_FLAGS="--compiler-bindir;$(cuda_gccdir)"
		)
	fi

	if use hip; then
		mycmakeargs+=(
			-DROCM_PATH="$(hipconfig -R)"
			-DHIP_HIPCC_FLAGS="-fcf-protection=none"
		)
	fi

	if use optix; then
		mycmakeargs+=(
			-DCYCLES_RUNTIME_OPTIX_ROOT_DIR="${EPREFIX}"/opt/optix
			-DOPTIX_ROOT_DIR="${EPREFIX}"/opt/optix
		)
	fi

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	use arm64 && append-flags -flax-vector-conversions

	append-cflags "$(usex debug '-DDEBUG' '-DNDEBUG')"
	append-cppflags "$(usex debug '-DDEBUG' '-DNDEBUG')"

	if tc-is-gcc ; then
		# These options only exist when GCC is detected.
		# We disable these to respect the user's choice of linker.
		mycmakeargs+=(
			-DWITH_LINKER_GOLD=no
			-DWITH_LINKER_LLD=no
		)
		# Ease compiling with required gcc similar to cuda_sanitize but for cmake
		use cuda && use cycles-bin-kernels && mycmakeargs+=( -DCUDA_HOST_COMPILER="$(cuda_gccdir)" )
	fi

	if tc-is-clang || use osl; then
		mycmakeargs+=(
			-DWITH_CLANG=yes
			-DWITH_LLVM=yes
		)
	fi

	if use test ; then
		local CYCLES_TEST_DEVICES=( "CPU" )
		if use cycles-bin-kernels; then
			use cuda && CYCLES_TEST_DEVICES+=( "CUDA" )
			use optix && CYCLES_TEST_DEVICES+=( "OPTIX" )
			use hip && CYCLES_TEST_DEVICES+=( "HIP" )
		fi
		mycmakeargs+=(
			-DCYCLES_TEST_DEVICES:STRING="$(local IFS=";"; echo "${CYCLES_TEST_DEVICES[*]}")"
			-DWITH_COMPOSITOR_REALTIME_TESTS=yes
			-DWITH_GPU_DRAW_TESTS=yes
			-DWITH_GPU_RENDER_TESTS=yes
		)
	fi

	cmake_src_configure
}

src_test() {
	# A lot of tests needs to have access to the installed data files.
	# So install them into the image directory now.
	DESTDIR="${T}" cmake_build install

	blender_get_version
	# Define custom blender data/script file paths not be able to find them otherwise during testing.
	# (Because the data is in the image directory and it will default to look in /usr/share)
	export BLENDER_SYSTEM_SCRIPTS="${T}/usr/share/blender/${BV}/scripts"
	export BLENDER_SYSTEM_DATAFILES="${T}/usr/share/blender/${BV}/datafiles"

	# Sanity check that the script and datafile path is valid.
	# If they are not vaild, blender will fallback to the default path which is not what we want.
	[ -d "$BLENDER_SYSTEM_SCRIPTS" ] || die "The custom script path is invalid, fix the ebuild!"
	[ -d "$BLENDER_SYSTEM_DATAFILES" ] || die "The custom datafiles path is invalid, fix the ebuild!"

	if use cuda; then
		cuda_add_sandbox -w
		addwrite "/dev/dri/renderD128"
		addwrite "/dev/char/"
	fi

	if use X; then
		xdg_environment_reset
	fi

	cmake_src_test

	# Clean up the image directory for src_install
	rm -fr "${T}/usr" || die
}

src_install() {
	blender_get_version

	# Pax mark blender for hardened support.
	pax-mark m "${BUILD_DIR}"/bin/blender

	cmake_src_install

	if use man; then
		# Slot the man page
		mv "${ED}/usr/share/man/man1/blender.1" "${ED}/usr/share/man/man1/blender-${BV}.1" || die
	fi

	if use doc; then
		# Define custom blender data/script file paths. Otherwise Blender will not be able to find them during doc building.
		# (Because the data is in the image directory and it will default to look in /usr/share)
		export BLENDER_SYSTEM_SCRIPTS=${ED}/usr/share/blender/${BV}/scripts
		export BLENDER_SYSTEM_DATAFILES=${ED}/usr/share/blender/${BV}/datafiles

		# Workaround for binary drivers.
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

		einfo "Generating Blender C/C++ API docs ..."
		cd "${CMAKE_USE_DIR}"/doc/doxygen || die
		doxygen -u Doxyfile || die
		doxygen || die "doxygen failed to build API docs."

		cd "${CMAKE_USE_DIR}" || die
		einfo "Generating (BPY) Blender Python API docs ..."
		"${BUILD_DIR}"/bin/blender --background --python doc/python_api/sphinx_doc_gen.py -noaudio || die "sphinx failed."

		cd "${CMAKE_USE_DIR}"/doc/python_api || die
		sphinx-build sphinx-in BPY_API || die "sphinx failed."

		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	# Fix doc installdir
	docinto html
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED}"/usr/share/doc/blender || die

	python_optimize "${ED}/usr/share/blender/${BV}/scripts"

	mv "${ED}/usr/bin/blender-thumbnailer" "${ED}/usr/bin/blender-${BV}-thumbnailer" || die
	mv "${ED}/usr/bin/blender" "${ED}/usr/bin/blender-${BV}" || die
}

pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherent risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "changing the 'Temporary Files' directory in Blender preferences."
	elog

	if use osl; then
		ewarn ""
		ewarn "OSL is know to cause runtime segfaults if Mesa has been linked to"
		ewarn "an other LLVM version than what OSL is linked to."
		ewarn "See https://bugs.gentoo.org/880671 for more details"
		ewarn ""
	fi

	if ! use python_single_target_python3_11; then
		elog "You are building Blender with a newer python version than"
		elog "supported by this version upstream."
		elog "If you experience breakages with e.g. plugins, please switch to"
		elog "python_single_target_python3_11 instead."
		elog "Bug: https://bugs.gentoo.org/737388"
		elog
	fi

	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${BV}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
}
