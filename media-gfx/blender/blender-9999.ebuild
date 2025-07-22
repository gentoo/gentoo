# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# shellcheck disable=SC2207

# TODO
# - Package Hydra
# 	https://github.com/Ray-Tracing-Systems/HydraCore
# 	https://github.com/Ray-Tracing-Systems/HydraAPI
# - Package USD
# 	https://github.com/PixarAnimationStudios/OpenUSD
# - Package MaterialX
# 	https://github.com/AcademySoftwareFoundation/MaterialX
# - Package Draco
# 	https://github.com/google/draco
# - Package Audaspace
# 	https://github.com/neXyon/audaspace

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
# NOTE must match media-libs/osl
LLVM_COMPAT=( {18..19} )
LLVM_OPTIONAL=1

ROCM_SKIP_GLOBALS=1

inherit cuda rocm llvm-r1
inherit eapi9-pipestatus check-reqs flag-o-matic pax-utils python-single-r1 toolchain-funcs virtualx
inherit cmake xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

# NOTE BLENDER_VERSION
# https://projects.blender.org/blender/blender/src/branch/main/source/blender/blenkernel/BKE_blender_version.h
BLENDER_BRANCH="$(ver_cut 1-2)"

if [[ "${PV}" == *9999* ]]; then
	EGIT_LFS="yes"
	inherit git-r3
	EGIT_REPO_URI="https://projects.blender.org/blender/blender.git"
	EGIT_SUBMODULES=( '*' '-lib/*' )

	if [[ "${PV}" == 9999* ]]; then
		EGIT_BRANCH="main"
	else
		EGIT_BRANCH="blender-v${BLENDER_BRANCH}-release"
	fi

else
	SRC_URI="
		https://download.blender.org/source/${P}.tar.xz
		test? (
			https://download.blender.org/source/blender-test-data-${BLENDER_BRANCH}.0.tar.xz
		)
	"
	KEYWORDS="~amd64 ~arm ~arm64"
fi

# assets is CC0-1.0
LICENSE="GPL-3+ cycles? ( Apache-2.0 ) CC0-1.0"
SLOT="${BLENDER_BRANCH}"

# NOTE +openpgl breaks on very old amd64 hardware
# potentially mirror cpu_flags_x86 + REQUIRED_USE
IUSE="
	alembic +bullet collada +color-management cuda +cycles +cycles-bin-kernels
	debug doc +embree +ffmpeg +fftw +fluid +gmp gnome hip jack
	+jemalloc jpeg2k man +manifold +nanovdb ndof nls +oidn oneapi openal +openexr +opengl +openpgl
	+opensubdiv +openvdb optix osl pipewire +pdf +potrace +pugixml pulseaudio
	renderdoc sdl +sndfile +tbb test +tiff +truetype valgrind vulkan wayland +webp X
"

if [[ "${PV}" == *9999* ]]; then
	IUSE+="experimental"
fi

RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( opengl vulkan )
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
	test? (
		color-management
		jpeg2k
	)
"

# Library versions for official builds can be found in the blender source directory in:
# build_files/build_environment/cmake/versions.cmake
RDEPEND="${PYTHON_DEPS}
	app-arch/zstd
	dev-cpp/gflags:=
	dev-cpp/glog:=
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
	virtual/opengl[X?]
	alembic? ( >=media-gfx/alembic-1.8.3-r2[boost(+),hdf(+)] )
	bullet? ( sci-physics/bullet:=[double-precision] )
	collada? ( >=media-libs/opencollada-1.6.68 )
	color-management? ( media-libs/opencolorio:= )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	embree? ( media-libs/embree:=[raymask] )
	ffmpeg? ( media-video/ffmpeg:=[encode(+),lame(-),jpeg2k?,opus,theora,vorbis,vpx,x264,xvid] )
	fftw? ( sci-libs/fftw:3.0=[threads] )
	gmp? ( dev-libs/gmp[cxx] )
	gnome? ( gui-libs/libdecor )
	hip? (
		>=dev-util/hip-5.7:=
	)
	jack? ( virtual/jack )
	jemalloc? ( dev-libs/jemalloc:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	manifold? ( >=sci-mathematics/manifold-3.1.0:= )
	ndof? (
		app-misc/spacenavd
		dev-libs/libspnav
	)
	nls? ( virtual/libiconv )
	openal? ( media-libs/openal )
	oidn? ( >=media-libs/oidn-2.1.0 )
	oneapi? ( dev-libs/intel-compute-runtime:=[l0] )
	openexr? (
		>=dev-libs/imath-3.1.7:=
		>=media-libs/openexr-3.2.1:0=
	)
	openpgl? ( media-libs/openpgl:= )
	opensubdiv? ( >=media-libs/opensubdiv-3.6.0-r2[opengl,cuda?,tbb?] )
	openvdb? (
		>=media-gfx/openvdb-11.0.0:=[nanovdb?]
		dev-libs/c-blosc:=
	)
	optix? ( <dev-libs/optix-9:= )
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
	truetype? (
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
"

if [[ "${PV}" == *9999* ]]; then
DEPEND+="
	test? (
		experimental? (
			wayland? (
				dev-libs/weston
			)
		)
	)
"
fi

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
	vulkan? (
		dev-util/spirv-headers
		dev-util/vulkan-headers
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
	"${FILESDIR}/${PN}-4.1.1-FindLLVM.patch"
	"${FILESDIR}/${PN}-4.1.1-numpy.patch"
	"${FILESDIR}/${PN}-4.3.2-system-glog.patch"
	"${FILESDIR}/${PN}-4.4.0-optix-compile-flags.patch"
)

blender_check_requirements() {
	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

blender_get_version() {
	if [[ -n "${BV}" && -n "${BVC}" ]]; then
		return
	fi

	local status
	# Get blender version from blender itself.
	# mirrors build_files/cmake/macros.cmake function(get_blender_version)
	# NOTE maps x0y to x.y
	# TODO this can potentially break for x > 9 and y > 9
	BV="$(grep "define BLENDER_VERSION " source/blender/blenkernel/BKE_blender_version.h | cut -d ' ' -f 3)"
	status="$(pipestatus -v)" || die "fails to detect BLENDER_VERSION, (PIPESTATUS: ${status})"
	BV="$(printf "%d.%d" "${BV:0: -2}" "${BV: -2}")"

	if [[ "${PV}" != 9999* && "${BLENDER_BRANCH}" != "${BV}" ]]; then
		eerror "ebuild (${BLENDER_BRANCH}) and code (${BV}) version mismatch"
		die "blender_get_version"
	fi

	BVC="$(grep "define BLENDER_VERSION_CYCLE " source/blender/blenkernel/BKE_blender_version.h | cut -d ' ' -f 3)"
	status="$(pipestatus -v)" || die "fails to detect BLENDER_VERSION_CYCLE, (PIPESTATUS: ${status})"
}

pkg_pretend() {
	blender_check_requirements

	if use oneapi; then
		einfo "The Intel oneAPI support is rudimentary."
		einfo ""
		einfo "Please report any bugs you find to https://bugs.gentoo.org/"
		if ! command -v icpx &>/dev/null && ! command -v dpcpp &>/dev/null; then
			eerror "Could not find icpx or dpcpp."
			eerror "You need SYCL/DCP++ to enable oneapi support."
			eerror "Try sys-devel/DPC++::science"
			die "FindSYCL would fail. Aborting."
		fi
	fi
}

pkg_setup() {
	blender_check_requirements
	python-single-r1_pkg_setup

	if use osl; then
		llvm-r1_pkg_setup
	fi
}

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		if ! use test; then
			EGIT_SUBMODULES+=( '-tests/*' )
		fi
		git-r3_src_unpack
	else
		default

		# TODO
		if use test && [[ ${PV} != ${SLOT}.0 ]] ; then
			mv "blender-${BLENDER_BRANCH}.0/tests/"* "${S}/tests" || die
		fi
	fi
}

src_prepare() {
	use cuda && cuda_src_prepare

	cmake_src_prepare

	blender_get_version

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

	sed \
		-e "/CMAKE_INSTALL_PREFIX_WITH_CONFIG/{s|\${CMAKE_INSTALL_PREFIX}|${T}\${CMAKE_INSTALL_PREFIX}|g}" \
		-i CMakeLists.txt \
		|| die CMAKE_INSTALL_PREFIX_WITH_CONFIG

	# WITH_SYSTEM_GLOG=yes
	cmake_run_in extern cmake_comment_add_subdirectory glog

	mv \
		"release/freedesktop/icons/scalable/apps/blender.svg" \
		"release/freedesktop/icons/scalable/apps/blender-${BV}.svg" \
		|| die
	mv \
		"release/freedesktop/icons/symbolic/apps/blender-symbolic.svg" \
		"release/freedesktop/icons/symbolic/apps/blender-${BV}-symbolic.svg" \
		|| die
	mv \
		"release/freedesktop/blender.desktop" \
		"release/freedesktop/blender-${BV}.desktop" \
		|| die

	mv \
		"release/freedesktop/org.blender.Blender.metainfo.xml" \
		"release/freedesktop/blender-${BV}.metainfo.xml" \
		|| die

	sed \
		-e "s#\(set(cycles_kernel_runtime_lib_target_path \)\${cycles_kernel_runtime_lib_target_path}\(/lib)\)#\1\${CYCLES_INSTALL_PATH}\2#" \
		-i intern/cycles/kernel/CMakeLists.txt \
		|| die

	if use hip; then
		# fix hardcoded path
		sed \
			-e "s#opt/rocm/hip/bin#$(hipconfig -p)/bin#g" \
			-i extern/hipew/src/hipew.c \
			|| die
	fi

	if use test; then
		# Without this the tests will try to use /usr/bin/blender and /usr/share/blender/ to run the tests.
		sed \
			-e "/string(REPLACE.*TEST_INSTALL_DIR/{s|\${CMAKE_INSTALL_PREFIX}|${T}\${CMAKE_INSTALL_PREFIX}|g}" \
			-i "build_files/cmake/testing.cmake" \
			|| die "REPLACE.*TEST_INSTALL_DIR"

		# assertEquals was deprecated in Python-3.2 use assertEqual instead
		sed \
			-e 's/assertEquals/assertEqual/g' \
			-i tests/python/bl_animation_action.py \
			|| die

		sed -e '1i #include <cstdint>' -i extern/gtest/src/gtest-death-test.cc || die
	else
		cmake_comment_add_subdirectory tests
	fi

	rm -rf extern/gflags || die
}

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/859607
	# https://projects.blender.org/blender/blender/issues/120444
	filter-lto

	# Workaround for bug #922600
	append-ldflags "$(test-flags-CCLD -Wl,--undefined-version)"

	append-lfs-flags
	blender_get_version

	local mycmakeargs=(
		# we build a host-specific binary
		-DWITH_CPU_CHECK="no"

		-DWITH_STRICT_BUILD_OPTIONS="yes"
		-DWITH_LIBS_PRECOMPILED="no"
		-DBUILD_SHARED_LIBS="no" # quadriflow only?
		-DWITH_STATIC_LIBS=OFF

		# Build Options:
		-DWITH_ALEMBIC="$(usex alembic)"
		-DWITH_BOOST="yes"
		-DWITH_BULLET="$(usex bullet)"
		-DWITH_CYCLES="$(usex cycles)"
		-DWITH_DOC_MANPAGE="$(usex man)"
		-DWITH_FFTW3="$(usex fftw)"
		-DWITH_GMP="$(usex gmp)"
		-DWITH_GTESTS="$(usex test)"
		-DWITH_HARFBUZZ="$(usex truetype)"
		-DWITH_HARU="$(usex pdf)"
		-DWITH_HEADLESS="$(usex !X "$(usex !wayland)")"
		-DWITH_INPUT_NDOF="$(usex ndof)"
		-DWITH_INTERNATIONAL="$(usex nls)"
		-DWITH_MANIFOLD="$(usex manifold)"
		-DWITH_MATERIALX="no" # TODO: Package MaterialX
		-DWITH_NANOVDB="$(usex nanovdb)"
		-DWITH_OPENCOLLADA="$(usex collada)"
		-DWITH_OPENCOLORIO="$(usex color-management)"
		-DWITH_OPENGL_BACKEND="$(usex opengl)"
		-DWITH_OPENIMAGEDENOISE="$(usex oidn)"
		-DWITH_OPENSUBDIV="$(usex opensubdiv)"
		-DWITH_OPENVDB="$(usex openvdb)"
		-DWITH_OPENVDB_BLOSC="$(usex openvdb)"
		-DWITH_POTRACE="$(usex potrace)"
		-DWITH_PUGIXML="$(usex pugixml)"
		# -DWITH_QUADRIFLOW=ON
		-DWITH_RENDERDOC="$(usex renderdoc)"
		-DWITH_TBB="$(usex tbb)"
		-DWITH_UNITY_BUILD="no"
		-DWITH_USD="no" # TODO: Package USD
		-DWITH_VULKAN_BACKEND="$(usex vulkan)" # experimental
		-DWITH_XR_OPENXR="no"

		-DWITH_SYSTEM_BULLET="yes"
		-DWITH_SYSTEM_EIGEN3="yes"
		-DWITH_SYSTEM_FREETYPE="yes"
		-DWITH_SYSTEM_GFLAGS="yes"
		-DWITH_SYSTEM_GLOG="yes"
		-DWITH_SYSTEM_LZO="yes"

		# Compiler Options:
		# -DWITH_BUILDINFO="yes"

		# System Options:
		-DWITH_INSTALL_PORTABLE="no"
		-DWITH_MEM_JEMALLOC="$(usex jemalloc)"
		-DWITH_MEM_VALGRIND="$(usex valgrind)"

		# GHOST Options:
		-DWITH_GHOST_WAYLAND="$(usex wayland)"
		# -DWITH_GHOST_WAYLAND_APP_ID="blender-${BV}"
		-DWITH_GHOST_WAYLAND_DYNLOAD="no"
		-DWITH_GHOST_X11="$(usex X)"
		# -DWITH_GHOST_XDND=ON
		# -DWITH_X11_XF86VMODE=ON
		# -DWITH_X11_XFIXES=ON
		# -DWITH_X11_XINPUT=ON
		# -DWITH_GHOST_WAYLAND_DYNLOAD # visible wayland?
		# -DWITH_GHOST_WAYLAND_LIBDECOR # visible wayland?

		# Image Formats:
		# -DWITH_IMAGE_CINEON=ON
		-DWITH_IMAGE_OPENEXR="$(usex openexr)"
		-DWITH_IMAGE_OPENJPEG="$(usex jpeg2k)"
		-DWITH_IMAGE_WEBP="$(usex webp)" # unlisted

		# Audio:
		# -DWITH_AUDASPACE=OFF
		# -DWITH_SYSTEM_AUDASPACE=OFF
		-DWITH_CODEC_FFMPEG="$(usex ffmpeg)"
		-DWITH_CODEC_SNDFILE="$(usex sndfile)"
		# -DWITH_COREAUDIO=OFF
		-DWITH_JACK="$(usex jack)"
		# -DWITH_JACK_DYNLOAD=
		-DWITH_OPENAL="$(usex openal)"
		-DWITH_PIPEWIRE="$(usex pipewire)"
		# -DWITH_PIPEWIRE_DYNLOAD=
		-DWITH_PULSEAUDIO="$(usex pulseaudio)"
		# -DWITH_PULSEAUDIO_DYNLOAD=
		-DWITH_SDL="$(usex sdl)"
		# -DWITH_WASAPI=OFF

		# Python:
		# -DWITH_PYTHON=ON
		-DWITH_PYTHON_INSTALL="no"
		-DWITH_PYTHON_INSTALL_NUMPY="no"
		-DWITH_PYTHON_INSTALL_ZSTANDARD="no"
		# -DWITH_PYTHON_MODULE="no"
		-DWITH_PYTHON_SAFETY="OFF"
		-DWITH_PYTHON_SECURITY="yes"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DWITH_DRACO="yes" # TODO: Package Draco # NOTE use bundled for now

		# Modifiers:
		-DWITH_MOD_FLUID="$(usex fluid)"
		# -DWITH_MOD_REMESH=ON
		-DWITH_MOD_OCEANSIM="$(usex fftw)"

		# Rendering:
		-DWITH_HYDRA="no" # TODO: Package Hydra

		# Rendering (Cycles):
		-DWITH_CYCLES_OSL="$(usex osl)"
		-DWITH_CYCLES_EMBREE="$(usex embree)"
		-DWITH_CYCLES_PATH_GUIDING="$(usex openpgl)"

		-DWITH_CYCLES_DEVICE_OPTIX="$(usex optix)"
		-DWITH_CYCLES_DEVICE_CUDA="$(usex cuda)"
		-DWITH_CYCLES_CUDA_BINARIES="$(usex cuda "$(usex cycles-bin-kernels)")"

		-DWITH_CYCLES_DEVICE_ONEAPI="$(usex oneapi)"
		-DWITH_CYCLES_ONEAPI_BINARIES="$(usex oneapi "$(usex cycles-bin-kernels)")"
		-DWITH_CYCLES_DEVICE_HIP="$(usex hip)"
		-DWITH_CYCLES_HIP_BINARIES="$(usex hip "$(usex cycles-bin-kernels)")"
		-DWITH_CYCLES_HYDRA_RENDER_DELEGATE="no" # TODO: package Hydra

		# -DWITH_CYCLES_STANDALONE=OFF
		# -DWITH_CYCLES_STANDALONE_GUI=OFF

		-DWITH_BLENDER_THUMBNAILER="yes"
	)

	if has_version ">=dev-python/numpy-2"; then
		mycmakeargs+=(
			-DPYTHON_NUMPY_INCLUDE_DIRS="$(python_get_sitedir)/numpy/_core/include"
			-DPYTHON_NUMPY_PATH="$(python_get_sitedir)/numpy/_core/include"
		)
	fi

	# requires dev-vcs/git
	if [[ "${PV}" == *9999* && "${BVC}" == "alpha" ]]; then
		mycmakeargs+=(
			# -DWITH_BUILDINFO="no"
			-DWITH_EXPERIMENTAL_FEATURES="$(usex experimental)"
		)
	else
		mycmakeargs+=(
			-DWITH_EXPERIMENTAL_FEATURES="no"
		)
	fi

	if use cuda; then
		# Ease compiling with required gcc similar to cuda_sanitize but for cmake
		if use cycles-bin-kernels; then
			local -x CUDAHOSTCXX="$(cuda_gccdir)"
			local -x CUDAHOSTLD="$(tc-getCXX)"

			if [[ -n "${CUDAARCHS}" ]]; then
				mycmakeargs+=(
					-DCYCLES_CUDA_BINARIES_ARCH="$(echo "${CUDAARCHS}" | sed -e 's/^/sm_/g' -e 's/;/;sm_/g')"
				)
			fi
		fi
	fi

	if use hip; then
		mycmakeargs+=(
			-DHIP_ROOT_DIR="$(hipconfig -p)"

			-DCYCLES_HIP_BINARIES_ARCH="$(get_amdgpu_flags)"
		)
	fi

	if use optix; then
		mycmakeargs+=(
			-DCYCLES_RUNTIME_OPTIX_ROOT_DIR="${ESYSROOT}/opt/optix"
			-DOPTIX_ROOT_DIR="${ESYSROOT}/opt/optix"
		)
	fi

	if use wayland; then
		mycmakeargs+=(
			-DWITH_GHOST_WAYLAND_APP_ID="blender-${BV}"
			-DWITH_GHOST_WAYLAND_LIBDECOR="$(usex gnome)"
		)
	fi

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	use arm64 && append-flags -flax-vector-conversions

	append-cflags "$(usex debug '-DDEBUG' '-DNDEBUG')"
	append-cxxflags "$(usex debug '-DDEBUG' '-DNDEBUG')"

	if tc-is-gcc; then
		# We disable these to respect the user's choice of linker.
		mycmakeargs+=(
			-DWITH_LINKER_GOLD="no"
		)
	fi

	if tc-is-clang || use osl; then
		mycmakeargs+=(
			-DWITH_CLANG="yes"
			-DWITH_LLVM="yes"
		)
	fi

	if use test; then
		local CYCLES_TEST_DEVICES=( "CPU" )
		if use cycles-bin-kernels; then
			use cuda && CYCLES_TEST_DEVICES+=( "CUDA" )
			use optix && CYCLES_TEST_DEVICES+=( "OPTIX" )
			use hip && CYCLES_TEST_DEVICES+=( "HIP" )
			use oneapi && CYCLES_TEST_DEVICES+=( "ONEAPI" )
		fi
		mycmakeargs+=(
			-DCMAKE_INSTALL_PREFIX_WITH_CONFIG="${T}/usr"
			-DCYCLES_TEST_DEVICES="$(local IFS=";"; echo "${CYCLES_TEST_DEVICES[*]}")"
		)

		# NOTE in lieu of a FEATURE/build_options
		if [[ "${EXPENSIVE_TESTS:-0}" -gt 0 ]]; then
			einfo "running expensive tests EXPENSIVE_TESTS=${EXPENSIVE_TESTS}"
			mycmakeargs+=(
				-DWITH_CYCLES_TEST_OSL="$(usex osl)"

				-DWITH_GPU_BACKEND_TESTS="yes"
				-DWITH_GPU_COMPOSITOR_TESTS="yes"

				-DWITH_GPU_DRAW_TESTS="yes"

				-DWITH_GPU_RENDER_TESTS="no"
				-DWITH_GPU_RENDER_TESTS_HEADED="no"
				-DWITH_GPU_RENDER_TESTS_SILENT="yes"
				-DWITH_GPU_RENDER_TESTS_VULKAN="$(usex vulkan)"

				-DWITH_SYSTEM_PYTHON_TESTS="yes"
				-DTEST_SYSTEM_PYTHON_EXE="${PYTHON}"
			)

			if [[ "${PV}" == *9999* && "${BVC}" == "alpha" ]] && use experimental; then
				mycmakeargs+=(
					# Enable user-interface tests using a headless display server.
					# Currently this depends on WITH_GHOST_WAYLAND and the weston compositor (Experimental)
					-DWITH_UI_TESTS="$(usex wayland)"
					-DWESTON_BIN="${ESYSROOT}/usr/bin/weston"
				)
			fi
		else
			mycmakeargs+=(
				-DWITH_GPU_RENDER_TESTS="no"
			)
		fi
	fi

	cmake_src_configure
}

src_test() {
	# A lot of tests need to have access to the installed data files.
	# So install them into the image directory now.
	DESTDIR="${T}" cmake_build install

	blender_get_version
	# Define custom blender data/script file paths, or we won't be able to find them otherwise during testing.
	# (Because the data is in the image directory and it will default to look in /usr/share)
	local -x BLENDER_SYSTEM_RESOURCES="${T%/}/usr/share/blender/${BV}"

	# Sanity check that the script and datafile path is valid.
	# If they are not valid, blender will fallback to the default path which is not what we want.
	[[ -d "${BLENDER_SYSTEM_RESOURCES}" ]] || die "The custom resources path is invalid, fix the ebuild!"

	# TODO only picks first card
	addwrite "/dev/dri/card0"
	addwrite "/dev/dri/renderD128"
	addwrite "/dev/udmabuf"

	if use cuda; then
		cuda_add_sandbox -w
		addwrite "/proc/self/task"
		addpredict "/dev/char/"
	fi

	local -x CMAKE_SKIP_TESTS=(
		"^compositor_cpu_color$"
		"^compositor_cpu_filter$"
		"^cycles_image_colorspace_cpu$"
		"^script_pyapi_bpy_driver_secure_eval$"
	)

	if [[ "${RUN_FAILING_TESTS:-0}" -eq 0 ]]; then
		einfo "not running failing tests RUN_FAILING_TESTS=${RUN_FAILING_TESTS}"
		CMAKE_SKIP_TESTS+=(
			"^cycles_bsdf_cuda$"
			"^cycles_image_data_types_cpu$"
			"^cycles_image_data_types_optix$"
			"^cycles_image_mapping_cpu$"
			"^cycles_osl_cpu$"
		)
	fi

	if ! has_version "media-libs/openusd"; then
		CMAKE_SKIP_TESTS+=(
			# from pxr import Usd # ModuleNotFoundError: No module named 'pxr'
			"^script_bundled_modules$"
		)
	fi

	if ! has_version "media-libs/openimageio[python]"; then
		CMAKE_SKIP_TESTS+=(
			# import OpenImageIO as oiio # ModuleNotFoundError: No module named 'OpenImageIO'
			"^compositor_cpu_file_output$"
		)
	fi

	# oiio can't find webp due to missing cmake files # 937031
	sed -e "s/ WEBP//g" -i "${BUILD_DIR}/tests/python/CTestTestfile.cmake" || die

	# For debugging, print out all information.
	local -x VERBOSE="$(usex debug "true" "false")"
	"${VERBOSE}" && einfo "VERBOSE=${VERBOSE}"

	# Show the window in the foreground.
	# local -x USE_WINDOW="true" # non-zero
	[[ -v USE_WINDOW ]] && einfo "USE_WINDOW=${USE_WINDOW}"

	# local -x USE_DEBUG="true" # non-zero
	[[ -v USE_DEBUG ]] && einfo "USE_DEBUG=${USE_DEBUG}"

	if [[ "${EXPENSIVE_TESTS:-0}" -gt 0 ]]; then
		einfo "running expensive tests EXPENSIVE_TESTS=${EXPENSIVE_TESTS}"
		# if [[ "${PV}" == *9999* && "${BVC}" == "alpha" ]] &&
		# 	use experimental && use wayland; then
		# 		# This runs weston
		# 		xdg_environment_reset
		# fi

		xdg_environment_reset
		# WITH_GPU_RENDER_TESTS_HEADED
		if use wayland; then
			local compositor exit_code
			local logfile=${T}/weston.log
			weston --xwayland --backend=headless --socket=wayland-5 --idle-time=0 2>"${logfile}" &
			compositor=$!
			local -x WAYLAND_DISPLAY=wayland-5
			sleep 1 # wait for xwayland to be up
			# TODO use eapi9-pipestatus
			local -x DISPLAY="$(grep "xserver listening on display" "${logfile}" | cut -d ' ' -f 5)"

			cmake_src_test

			exit_code=$?
			kill "${compositor}"
		elif use X; then
			virtx cmake_src_test
		else
			cmake_src_test
		fi
	else
		cmake_src_test
	fi

	# Clean up the image directory for src_install
	rm -fr "${T}/usr" || die
}

src_install() {
	blender_get_version

	# Pax mark blender for hardened support.
	pax-mark m "${BUILD_DIR}/bin/blender"

	cmake_src_install

	if use man; then
		# Slot the man page
		mv "${ED}/usr/share/man/man1/blender.1" "${ED}/usr/share/man/man1/blender-${BV}.1" || die
	fi

	if use doc; then
		# Define custom blender data/script file paths. Otherwise Blender will not be able to find them during doc building.
		# (Because the data is in the image directory and it will default to look in /usr/share)
		local -x BLENDER_SYSTEM_RESOURCES="${ED}/usr/share/blender/${BV}"

		# Workaround for binary drivers. # TODO
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

		einfo "Generating Blender C/C++ API docs ..."
		cd "${CMAKE_USE_DIR}/doc/doxygen" || die
		doxygen -u Doxyfile || die
		doxygen || die "doxygen failed to build API docs."

		cd "${CMAKE_USE_DIR}" || die
		einfo "Generating (BPY) Blender Python API docs ..."
		"${BUILD_DIR}"/bin/blender --background --python "doc/python_api/sphinx_doc_gen.py" -noaudio || die "sphinx failed."

		cd "${CMAKE_USE_DIR}/doc/python_api" || die
		sphinx-build sphinx-in BPY_API || die "sphinx failed."

		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}/doc/python_api/BPY_API/"

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}/doc/doxygen/html/"
	fi

	# Fix doc installdir
	docinto html
	dodoc "${CMAKE_USE_DIR}/release/text/readme.html"
	rm -r "${ED}/usr/share/doc/blender" || die

	python_optimize "${ED}/usr/share/blender/${BV}/scripts"

	mv "${ED}/usr/bin/blender-thumbnailer" "${ED}/usr/bin/blender-${BV}-thumbnailer" \
		|| die "blender-thumbnailer version rename failed"
	mv "${ED}/usr/bin/blender" "${ED}/usr/bin/blender-${BV}" || die "blender version rename failed"
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

	if use osl && ! has_version "media-libs/mesa[${LLVM_USEDEP}]"; then
		ewarn ""
		ewarn "OSL is know to cause runtime segfaults if Mesa has been linked to"
		ewarn "an other LLVM version than what OSL is linked to."
		ewarn "See https://bugs.gentoo.org/880671 for more details"
		ewarn ""
	fi

	# NOTE build_files/cmake/Modules/FindPythonLibsUnix.cmake: set(_PYTHON_VERSION_SUPPORTED 3.11)
	if ! use python_single_target_python3_11; then
		elog "You are building Blender with a newer python version than"
		elog "supported by this version upstream."
		elog "If you experience breakages with e.g. plugins, please switch to"
		elog "PYTHON_SINGLE_TARGET: python3_11 instead."
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

	if [[ -z "${REPLACED_BY_VERSION}" ]]; then
		ewarn
		ewarn "You may want to remove the following directories"
		ewarn "- ~/.config/${PN}/${BV}/cache/"
		ewarn "- ~/.cache/cycles/"
		ewarn "It may contain extra render kernels not tracked by portage"
		ewarn
	fi
}
