# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran

inherit cmake fortran-2 flag-o-matic toolchain-funcs

MY_PV=${PV/_p/-}
MY_P=${PN}-${MY_PV}
MAJOR_P=${PN}-$(ver_cut 1-2)

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="https://github.com/HDFGroup/hdf5/"
SRC_URI="https://github.com/HDFGroup/hdf5/releases/download/${PN}_${MY_PV/-/.}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="NCSA-HDF"
SLOT="0/310-cmake"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="cxx debug fortran +hl mpi szip test threads unsupported zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	!unsupported? (
		?? ( cxx mpi )
		threads? ( !cxx !mpi !fortran !hl )
	)
"

DEPEND="
	mpi? ( virtual/mpi[romio,fortran?] )
	szip? ( virtual/szip )
	zlib? ( sys-libs/zlib:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/perl
"

PATCHES=(
	# https://github.com/HDFGroup/hdf5/pull/5361
	"${FILESDIR}"/hdf5-1.14.6-cmake-h5cc.patch
	# https://github.com/HDFGroup/hdf5/pull/5465
	"${FILESDIR}"/hdf5-1.14.6-h5cc-sh.patch
	# https://github.com/HDFGroup/hdf5/pull/5467
	"${FILESDIR}"/hdf5-1.14.6-override-compiler.patch
)

pkg_setup() {
	use fortran && fortran-2_pkg_setup

	if use mpi; then
		if has_version 'sci-libs/hdf5[-mpi]'; then
			ewarn "Installing hdf5 with mpi enabled with a previous hdf5 with mpi disabled may fail."
			ewarn "Try to uninstall the current hdf5 prior to enabling mpi support."
		fi

		export CC=mpicc
		use fortran && export FC=mpif90
	elif has_version 'sci-libs/hdf5[mpi]'; then
		ewarn "Installing hdf5 with mpi disabled while having hdf5 installed with mpi enabled may fail."
		ewarn "Try to uninstall the current hdf5 prior to disabling mpi support."
	fi
}

src_configure() {
	# bug #686620
	use sparc && tc-is-gcc && append-flags -fno-tree-ccp

	local mycmakeargs=(
		-DHDF5_INSTALL_CMAKE_DIR=$(get_libdir)/cmake/hdf5
		-DHDF5_INSTALL_LIB_DIR=$(get_libdir)
		# just COPYING
		-DHDF5_INSTALL_DATA_DIR=tmp
		# redundant to include?
		-DHDF5_INSTALL_MODULE_DIR=tmp
		-DHDF5_INSTALL_DOC_DIR=share/doc/${PF}
		-DH5_DEFAULT_PLUGINDIR="${EPREFIX}/usr/$(get_libdir)/${PN}/plugin"

		-DALLOW_UNSUPPORTED=$(usex unsupported)
		-DONLY_SHARED_LIBS=ON
		-DHDF5_BUILD_GENERATORS=OFF
		-DHDF5_ENABLE_TRACE=$(usex debug)
		-DHDF5_ENABLE_HDFS=OFF
		-DHDF5_ENABLE_PARALLEL=$(usex mpi)
		-DHDF5_ENABLE_SUBFILING_VFD=OFF
		-DHDF5_ENABLE_SZIP_SUPPORT=$(usex szip)
		-DHDF5_ENABLE_Z_LIB_SUPPORT=$(usex zlib)
		-DHDF5_ENABLE_THREADSAFE=$(usex threads)
		-DHDF5_ENABLE_MAP_API=OFF
		-DHDF5_BUILD_DOC=OFF
		-DBUILD_TESTING=$(usex test)
		-DHDF5_BUILD_PARALLEL_TOOLS=OFF
		-DHDF5_BUILD_TOOLS=ON
		-DHDF5_ENABLE_PLUGIN_SUPPORT=OFF
		-DHDF5_BUILD_HL_LIB=$(usex hl)
		-DHDF5_BUILD_FORTRAN=$(usex fortran)
		-DHDF5_BUILD_CPP_LIB=$(usex cxx)
		-DHDF5_BUILD_JAVA=OFF
		-DHDF5_BUILD_EXAMPLES=OFF
	)

	# do not force the compiler used for build
	if use mpi; then
		mycmakeargs+=( -DPKG_CONFIG_C_COMPILER=mpicc )
		use cxx && mycmakeargs+=( -DPKG_CONFIG_CXX_COMPILER=mpic++ )
		use fortran && mycmakeargs+=( -DPKG_CONFIG_Fortran_COMPILER=mpif90 )
	else
		mycmakeargs+=( -DPKG_CONFIG_C_COMPILER='${CC:-cc}' )
		use cxx && mycmakeargs+=( -DPKG_CONFIG_CXX_COMPILER='${CXX:-c++}' )
		use fortran &&
			mycmakeargs+=( -DPKG_CONFIG_Fortran_COMPILER='${FC:-gfortran}' )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -r "${ED}/usr/tmp" || die
}
