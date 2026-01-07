# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="threads(+),xml(+)"

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="C++ computer vision library emphasizing customizable algorithms and structures"
HOMEPAGE="https://ukoethe.github.io/vigra/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ukoethe/vigra.git"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]] ; then
		VIGRA_COMMIT="4db795574a471bf1d94d258361f1ef536dd87ac1"
		SRC_URI="
			https://github.com/ukoethe/vigra/archive/${VIGRA_COMMIT}.tar.gz
				-> ${P}.tar.gz
		"
		S="${WORKDIR}"/${PN}-${VIGRA_COMMIT}
	else
		SRC_URI="
			https://github.com/ukoethe/vigra/archive/refs/tags/Version-$(ver_rs 1- -).tar.gz
				-> ${P}.tar.gz
		"
		S="${WORKDIR}/${PN}-Version-$(ver_rs 1- -)"
	fi

	KEYWORDS="amd64 arm64 ~sparc x86 ~x64-solaris"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc +fftw +hdf5 +jpeg mpi openexr +png test +tiff +zlib"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	test? ( hdf5 fftw )
"
RESTRICT="!test? ( test )"

DEPEND="
	fftw? ( sci-libs/fftw:3.0= )
	hdf5? ( >=sci-libs/hdf5-1.8.0:=[mpi=] )
	jpeg? ( media-libs/libjpeg-turbo:= )
	openexr? (
		>=dev-libs/imath-3.1.4-r2:=
		>=media-libs/openexr-3:0=
	)
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:= )
	zlib? ( virtual/zlib:= )
"
# Python is needed as a runtime dep of installed vigra-config
RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
"
BDEPEND="
	doc? (
		app-text/doxygen
		dev-texlive/texlive-latex
	)
"

PATCHES=(
	# TODO: upstream
	"${FILESDIR}/${PN}-1.11.1-lib_suffix.patch"
	"${FILESDIR}/${PN}-1.11.1-cmake-module-dir.patch"

	"${FILESDIR}/${PN}-1.12.1-clang19.patch"
	"${FILESDIR}/${PN}-1.12.1-python311.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -i -e '/ADD_DEPENDENCIES(PACKAGE_SRC_TAR/d' CMakeLists.txt || die

	sed -i -e 's|@DOCDIR@|@CMAKE_INSTALL_PREFIX@/@DOCINSTALL@|' config/vigra-config.in || die
}

src_configure() {
	# Floating point error increases with -mfma leading to test failures
	append-flags -ffp-contract=off

	local mycmakeargs=(
		-DAUTOEXEC_TESTS=OFF
		-DAUTOBUILD_TESTS=$(usex test)
		-DDOCINSTALL="share/doc/${PF}/html"
		-DWITH_HDF5=$(usex hdf5)
		-DWITH_OPENEXR=$(usex openexr)
		-DWITH_VALGRIND=OFF # only used for tests
		-DWITH_VIGRANUMPY=OFF
		-DBUILD_TESTS=$(usex test)
		-DBUILD_DOCS=$(usex doc)
		$(cmake_use_find_package fftw FFTW3)
		$(cmake_use_find_package fftw FFTW3F)
		$(cmake_use_find_package jpeg JPEG)
		$(cmake_use_find_package png PNG)
		$(cmake_use_find_package tiff TIFF)
		$(cmake_use_find_package zlib ZLIB)
	)

	use doc && mycmakeargs+=( -DPython_EXECUTABLE=${PYTHON} )

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc_cpp
}

src_install() {
	cmake_src_install
	einstalldocs

	python_fix_shebang "${ED}"/usr/bin/vigra-config
}
