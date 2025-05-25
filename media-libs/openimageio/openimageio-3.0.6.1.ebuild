# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

TEST_OIIO_IMAGE_COMMIT="75099275c73a6937d40c69f9e14a006aa49fa201"
TEST_OEXR_IMAGE_COMMIT="d45a2d5a890d6963b94479c7a644440068c37dd2"
inherit cuda cmake flag-o-matic python-single-r1

DESCRIPTION="A library for reading and writing images"
HOMEPAGE="https://sites.google.com/site/openimageio/ https://github.com/AcademySoftwareFoundation/OpenImageIO"
SRC_URI="
	https://github.com/AcademySoftwareFoundation/OpenImageIO/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://github.com/AcademySoftwareFoundation/OpenImageIO-images/archive/${TEST_OIIO_IMAGE_COMMIT}.tar.gz
		 -> ${PN}-oiio-test-image-${TEST_OIIO_IMAGE_COMMIT}.tar.gz
		https://github.com/AcademySoftwareFoundation/openexr-images/archive/${TEST_OEXR_IMAGE_COMMIT}.tar.gz
		 -> ${PN}-oexr-test-image-${TEST_OEXR_IMAGE_COMMIT}.tar.gz
		jpeg2k? ( https://www.itu.int/wftp3/Public/t/testsignal/SpeImage/T803/v2002_11/J2KP4files.zip )

		fits? (
			https://www.cv.nrao.edu/fits/data/tests/ftt4b/file001.fits
			https://www.cv.nrao.edu/fits/data/tests/ftt4b/file002.fits
			https://www.cv.nrao.edu/fits/data/tests/ftt4b/file003.fits
			https://www.cv.nrao.edu/fits/data/tests/ftt4b/file009.fits
			https://www.cv.nrao.edu/fits/data/tests/ftt4b/file012.fits
			https://www.cv.nrao.edu/fits/data/tests/pg93/tst0001.fits
			https://www.cv.nrao.edu/fits/data/tests/pg93/tst0003.fits
			https://www.cv.nrao.edu/fits/data/tests/pg93/tst0005.fits
			https://www.cv.nrao.edu/fits/data/tests/pg93/tst0006.fits
			https://www.cv.nrao.edu/fits/data/tests/pg93/tst0007.fits
			https://www.cv.nrao.edu/fits/data/tests/pg93/tst0008.fits
			https://www.cv.nrao.edu/fits/data/tests/pg93/tst0013.fits
		)
	)
"
S="${WORKDIR}/OpenImageIO-${PV}"

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"

X86_CPU_FEATURES=(
	aes:aes
	sse2:sse2
	sse3:sse3
	ssse3:ssse3
	sse4_1:sse4.1
	sse4_2:sse4.2
	avx:avx
	avx2:avx2
	avx512f:avx512f
	f16c:f16c
)
CPU_FEATURES=( "${X86_CPU_FEATURES[@]/#/cpu_flags_x86_}" )

IUSE="cuda dicom doc ffmpeg fits gif gui jpeg2k opencv openvdb ptex python raw test +tools +truetype ${CPU_FEATURES[*]%:*}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) gui? ( tools ) test? ( tools truetype )"

RESTRICT="!test? ( test )"

BDEPEND="
	jpeg2k? ( app-arch/unzip )
	doc? (
		app-text/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"

# misses cmake files
# 	media-libs/libwebp:=
RDEPEND="
	dev-cpp/robin-map
	dev-libs/pugixml
	media-libs/libheif:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/opencolorio:=
	media-libs/openexr:=
	media-libs/tiff:=
	sys-libs/zlib:=
	dicom? ( sci-libs/dcmtk )
	ffmpeg? ( media-video/ffmpeg:= )
	fits? ( sci-libs/cfitsio:= )
	gif? ( media-libs/giflib:= )
	jpeg2k? ( media-libs/openjpeg:= )
	opencv? ( media-libs/opencv:= )
	openvdb? (
		dev-cpp/tbb:=
		media-gfx/openvdb:=
	)
	ptex? ( media-libs/ptex:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
	gui? (
		media-libs/libglvnd
		dev-qt/qtbase:6[gui,widgets,opengl]
	)
	raw? ( media-libs/libraw:= )
	truetype? ( media-libs/freetype )
"
DEPEND="
	dev-libs/imath:=
	dev-libs/libfmt:=
	${RDEPEND}
	test? ( media-fonts/droid )
"

DOCS=(
	CHANGES.md
	CREDITS.md
	README.md
)

PATCHES=(
	"${FILESDIR}/${PN}-2.5.8.0-fix-tests.patch"
	"${FILESDIR}/${PN}-2.5.12.0-heif-find-fix.patch"
	"${FILESDIR}/${PN}-2.5.18.0-tests-optional.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	if ! use dicom; then
		rm "src/dicom.imageio" -r || die
	fi

	if ! use gif; then
		rm src/gif.imageio -r || die
	fi

	if ! use jpeg2k; then
		rm src/jpeg2000.imageio -r || die
	fi

	if ! use raw; then
		rm src/raw.imageio -r || die
	fi

	cmake_src_prepare
	cmake_comment_add_subdirectory src/fonts

	if use test ; then
		ln -s "${WORKDIR}/OpenImageIO-images-${TEST_OIIO_IMAGE_COMMIT}" "${WORKDIR}/oiio-images" || die
		ln -s "${WORKDIR}/openexr-images-${TEST_OEXR_IMAGE_COMMIT}" "${WORKDIR}/openexr-images" || die

		if use fits; then
			mkdir -p "${WORKDIR}/fits-images/"{ftt4b,pg93} || die
			for a in ${A}; do
				if [[ "${a}" == file*.fits ]]; then
					ln -s "${DISTDIR}/${a}" "${WORKDIR}/fits-images/ftt4b/" || die
				fi
				if [[ "${a}" == tst*.fits ]]; then
					ln -s "${DISTDIR}/${a}" "${WORKDIR}/fits-images/pg93/" || die
				fi
			done
		fi

		if use jpeg2k; then
			ln -s "${WORKDIR}/J2KP4files" "${WORKDIR}/j2kp4files_v1_5" || die
		fi

		cp testsuite/heif/ref/out-libheif1.1{2,5}-orient.txt || die
		eapply "${FILESDIR}/${PN}-2.5.12.0_heif_test.patch"
	fi
}

src_configure() {
	# Build with SIMD support
	local cpufeature
	local mysimd=()
	for cpufeature in "${CPU_FEATURES[@]}"; do
		use "${cpufeature%:*}" && mysimd+=("${cpufeature#*:}")
	done

	# If no CPU SIMDs were used, completely disable them
	[[ -z ${mysimd[*]} ]] && mysimd=("0")

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	# Even if there are no SIMD features selected, it seems like the code will turn on NEON support if it is available.
	use arm64 && append-flags -flax-vector-conversions

	local mycmakeargs=(
		-DVERBOSE="no"

		# -DALWAYS_PREFER_CONFIG="yes"
		# -DGLIBCXX_USE_CXX11_ABI="yes"
		# -DTEX_BATCH_SIZE="8" # TODO AVX512 -> 16
		-DSTOP_ON_WARNING="no"

		-DCMAKE_CXX_STANDARD="17"
		-DDOWNSTREAM_CXX_STANDARD="17"

		-DCMAKE_UNITY_BUILD=OFF
		# -DCMAKE_UNITY_BUILD_MODE="BATCH"
		# -DUNITY_SMALL_BATCH_SIZE="$(nproc)"

		-DBUILD_DOCS="$(usex doc)"
		# -DBUILD_OIIOUTIL_ONLY="no"
		-DBUILD_TESTING="$(usex test)"

		-DINSTALL_FONTS="no"
		-DINSTALL_DOCS="$(usex doc)"

		-DENABLE_DCMTK="$(usex dicom)"
		-DENABLE_FFmpeg="$(usex ffmpeg)"
		-DENABLE_FITS="$(usex fits)"
		-DENABLE_FREETYPE="$(usex truetype)"
		-DENABLE_GIF="$(usex gif)"
		-DENABLE_LibRaw="$(usex raw)"
		-DENABLE_Nuke="no" # not in Gentoo
		-DENABLE_OpenCV="$(usex opencv)"
		-DENABLE_OpenJPEG="$(usex jpeg2k)"
		-DENABLE_OpenVDB="$(usex openvdb)"
		-DENABLE_TBB="$(usex openvdb)"
		-DENABLE_Ptex="$(usex ptex)"

		-DENABLE_GIF="$(usex gif)"
		-DENABLE_LIBRAW="$(usex raw)"
		-DENABLE_PTEX="$(usex ptex)"
		-DENABLE_OPENJPEG="$(usex jpeg2k)"

		-DENABLE_libuhdr="no" # not in Gentoo
		-DENABLE_WebP="no" # missing cmake files

		-DOIIO_BUILD_TOOLS="$(usex tools)"
		-DOIIO_BUILD_TESTS="$(usex test)"
		-DOIIO_DOWNLOAD_MISSING_TESTDATA="no"
		-DOIIO_USE_CUDA="$(usex cuda)"

		-DUSE_CCACHE="no"
		-DUSE_EXTERNAL_PUGIXML="yes"
		# -DUSE_LIBCPLUSPLUS="yes"
		-DUSE_R3DSDK="no" # not in Gentoo
		-DUSE_PYTHON="$(usex python)"
		-DUSE_SIMD="$(local IFS=','; echo "${mysimd[*]}")"
)

	if use gui; then
		mycmakeargs+=(
			-DUSE_IV="yes"
			-DUSE_OPENGL="yes"
			-DUSE_QT="yes"
		)
	else
		mycmakeargs+=(
			-DUSE_QT="no"
		)
	fi

	if use python; then
		mycmakeargs+=(
			"-DPYTHON_VERSION=${EPYTHON#python}"
			"-DPYTHON_SITE_DIR=$(python_get_sitedir)"
		)
	fi

	cmake_src_configure
}

src_test() {
	# A lot of tests needs to have access to the installed data files.
	# So install them into the image directory now.
	DESTDIR="${T}" cmake_build install

	if use cuda; then
		cuda_add_sandbox -w
		addpredict "/dev/char/"
	fi

	CMAKE_SKIP_TESTS=(
		"-broken$"
		"texture-levels-stochaniso.batch"

		"^docs-examples-cpp$"
		"^docs-examples-python$"
		"^python-imagebufalgo$"

		"^oiiotool-text$"
		"^bmp$"
		"^dds$"
		"^ico$"
		"^jpeg2000$"
		"^psd$"
		"^ptex$"

		"^tiff-depths" # TODO float errors
		"^tiff-suite" # TODO missing compression
	)

	sed -e "s#../../../testsuite#../../../OpenImageIO-${PV}/testsuite#g" \
		-i "${CMAKE_USE_DIR}/testsuite/python-imagebufalgo/ref/out.txt" || die

	# NOTE src/build-scripts/ci-startup.bash
	local -x CI CMAKE_PREFIX_PATH LD_LIBRARY_PATH OPENIMAGEIO_FONTS PYTHONPATH
	CI=true
	local -x OpenImageIO_CI=true
	# local -x OIIO_USE_CUDA=0
	CMAKE_PREFIX_PATH="${T}/usr"
	LD_LIBRARY_PATH="${T}/usr/$(get_libdir)"
	# local -x OPENIMAGEIO_DEBUG_FILE
	local -x OPENIMAGEIO_DEBUG=0

	if use python; then
		PYTHONPATH="${T}$(python_get_sitedir)"
	fi

	myctestargs=(
		--output-on-failure
	)

	cmake_src_test

	# Clean up the image directory for src_install
	rm -fr "${T:?}"/usr || die
}

src_install() {
	cmake_src_install

	# remove Windows loader file
	if use python; then
		rm "${D}$(python_get_sitedir)/__init__.py" || die
	fi
}
