# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake cuda flag-o-matic python-any-r1 toolchain-funcs virtualx xdg

MY_PV="$(ver_rs "1-3" '_')"

DESCRIPTION="An Open-Source subdivision surface library"
HOMEPAGE="https://graphics.pixar.com/opensubdiv/docs/intro.html"
SRC_URI="https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenSubdiv-${MY_PV}"

# Modfied Apache-2.0 license, where section 6 has been replaced.
# See for example CMakeLists.txt for details.
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="X cuda doc examples glfw opencl +opengl openmp ptex python tbb test tutorials"
RESTRICT="!test? ( test )"

# TODO needed for stringify due to unwrapped KERNEL_FILES in opensubdiv/{far,osd}/CMakeLists.txt
REQUIRED_USE="
	|| ( opencl opengl )
	ptex? ( glfw )
"

BDEPEND="
	doc? (
		app-text/doxygen
		dev-python/docutils
	)
	python? ( ${PYTHON_DEPS} )
"

# opengl requires GLX, libglvnd[X]
RDEPEND="
	examples? (
		opengl? (
			glfw? (
				>=media-libs/glfw-3.4[X?]
			)
		)
	)
	opengl? ( media-libs/libglvnd[X] )
	opencl? ( virtual/opencl )
	openmp? ( || (
		sys-devel/gcc:*[openmp]
		llvm-runtimes/openmp
	) )
	ptex? ( media-libs/ptex )
	tbb? ( dev-cpp/tbb:= )
	test? ( >=media-libs/glfw-3.4[X] )
"

# CUDA_RUNTIME is statically linked
DEPEND="
	${RDEPEND}
	test? (
		glfw? (
			>=media-libs/glfw-3.4[X?]
		)
	)
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.6.0-use-gnuinstalldirs.patch"
	"${FILESDIR}/${PN}-3.6.0-cudaflags.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use cuda; then
		# When building binary packages we build all major targets unless specified otherwise
		if [[ -z "${CUDAARCHS+x}" ]]; then
			case ${MERGE_TYPE} in
				source)    CUDAARCHS="native" ;;
				# buildonly) CUDAARCHS="all" ;;
				buildonly) CUDAARCHS="all-major" ;;
			esac
		fi

		# check if user provided --gpu-architecture/-arch flag instead of CUDAARCHS
		for f in ${NVCCFLAGS}; do
			if [[ ${f} == -arch* || ${f} == --gpu-architecture* ]]; then
				CUDAARCHS="NVCC"
				break
			fi
		done

		if [[ "${CUDAARCHS}" == "NVCC" ]]; then
			unset  CUDAARCHS
		else
			export CUDAARCHS
		fi
	fi
}

src_prepare() {
	cmake_src_prepare

	sed \
		-e "/install(/s/^/#DONOTINSTALL /g" \
		-i \
			regression/*/CMakeLists.txt \
			tools/stringify/CMakeLists.txt \
		|| die

	sed \
		-e "/install( TARGETS osd_static_[cg]pu/s/^/#DONOTINSTALL /g" \
		-i \
			opensubdiv/CMakeLists.txt \
		|| die

	if use cuda; then
		# do this little headstand to filter out lto from NVCCFLAGS
		local CFLAGS_orig="${CFLAGS}" CXXFLAGS_orig="${CXXFLAGS}"
		filter-lto

		cuda_src_prepare

		CFLAGS="${CFLAGS_orig}"
		CXXFLAGS="${CXXFLAGS_orig}"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR="share/${PN}/bin"

		# DirectX
		-DNO_DX="yes"

		# MacOS
		-DNO_MACOS_FRAMEWORK="yes"
		-DNO_METAL="yes"

		-DNO_DOC="$(usex !doc)"
		-DNO_EXAMPLES="$(usex !examples)"
		-DNO_TUTORIALS="$(usex !tutorials)"
		-DNO_REGRESSION="$(usex !test)"
		-DNO_TESTS="$(usex !test)"

		-DNO_PTEX="$(usex !ptex)"

		# GUI
		-DNO_OPENGL="$(usex !opengl)"

		# Backends
		-DNO_CUDA="$(usex !cuda)"
		-DNO_OMP="$(usex !openmp)"
		-DNO_TBB="$(usex !tbb)"
		-DNO_OPENCL="$(usex !opencl)"
	)

	if use cuda; then
		# The old cmake CUDA module doesn't use environment variable to initialize flags
		mycmakeargs+=(
			-DCUDA_PROPAGATE_HOST_FLAGS="no"
			-DCUDA_NVCC_FLAGS="-forward-unknown-opts ${NVCCFLAGS}"
		)
	fi

	if use opencl; then
		mycmakeargs+=(
			# not packaged https://github.com/martijnberger/clew
			-DNO_CLEW="yes"
		)
	fi

	if use opengl; then
		mycmakeargs+=(
			-DNO_GLTESTS="$(usex !test)"
			 # GLEW support is unmaintained in favour of their own GL handler code.
			 # Turning this on will lead to crashes when using their GPU backend.
			-DNO_GLEW="yes"
			-DNO_GLFW="$(usex !glfw)"
		)
		if use glfw; then
			mycmakeargs+=(
				-DGLFW_LOCATION="${ESYSROOT}/usr/$(get_libdir)"
				-DNO_GLFW_X11="$(usex !X)"
			)
		fi
	fi

	if use ptex; then
		mycmakeargs+=(
			-DPTEX_LOCATION="${ESYSROOT}/usr/$(get_libdir)"
		)
	fi

	if ! use python; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_Python="yes"
		)
	fi

	cmake_src_configure
}

src_test() {
	xdg_environment_reset

	CMAKE_SKIP_TESTS=(
		# Fails due to CL & CUDA kernels, works outside
		"glImaging"
	)

	if ! test -w /dev/dri/card0; then
		CMAKE_SKIP_TESTS+=(
			"osd_regression"
		)
	fi

	# "far_tutorial_1_2 breaks with gcc and > -O1"
	tc-is-gcc && is-flagq '-O@(2|3|fast)' && CMAKE_SKIP_TESTS+=( "far_tutorial_1_2" )

	if use cuda; then
		cuda_add_sandbox -w
		addpredict /dev/char/
		addwrite /dev/dri/card0
		addwrite /dev/dri/renderD128
		addwrite /dev/udmabuf
	fi

	virtx cmake_src_test

	if use examples && use opengl && use glfw; then

		local KERNELS=( CPU )
		use openmp && KERNELS+=( OPENMP )
		use tbb && KERNELS+=( TBB )

		# use cuda && KERNELS+=( CUDA )
		# use opencl && KERNELS+=( CL )

		use opengl && use X && KERNELS+=( XFB )
		use opengl && KERNELS+=( GLSL )

		#Bug https://bugs.gentoo.org/924516
		virtx "${BUILD_DIR}/bin/glImaging" -w test -l 3 -s 256 256 -a -k "$(IFS=","; echo "${KERNELS[*]}")"
	fi
}
