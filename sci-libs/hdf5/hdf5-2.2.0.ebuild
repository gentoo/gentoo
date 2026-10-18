# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran

inherit cmake fortran-2 flag-o-matic toolchain-funcs

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="https://github.com/HDFGroup/hdf5/"
SRC_URI="https://github.com/HDFGroup/hdf5/releases/download/${PV}/${P}.tar.gz"

LICENSE="NCSA-HDF"
SLOT="0/320-cmake"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="cxx debug fortran +hl mpi szip test threads unsupported zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	!unsupported? (
		?? ( cxx mpi )
		threads? ( !cxx !mpi !fortran !hl )
	)
"

# HDF5 2.x requires libaec's libsz compatibility library, so virtual/szip
# (which also allows sci-libs/szip) is not sufficient here.
DEPEND="
	mpi? ( virtual/mpi[romio,fortran?] )
	szip? ( sci-libs/libaec:=[szip] )
	zlib? ( virtual/zlib:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/perl
"

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
		# lib/cmake dirs follow CMAKE_INSTALL_LIBDIR from the eclass
		-DHDF5_USE_GNU_DIRS=ON
		# just LICENSE
		-DHDF5_INSTALL_DATA_DIR=tmp
		# redundant to include?
		-DHDF5_INSTALL_MODULE_DIR=tmp
		-DHDF5_INSTALL_DOC_DIR=share/doc/${PF}
		-DH5_DEFAULT_PLUGINDIR="${EPREFIX}/usr/$(get_libdir)/${PN}/plugin"

		-DHDF5_ALLOW_UNSUPPORTED=$(usex unsupported)
		-DHDF5_ONLY_SHARED_LIBS=ON
		-DHDF5_ENABLE_TRACE=$(usex debug)
		-DHDF5_ENABLE_HDFS=OFF
		# the direct VFD needs O_DIRECT, which is Linux-only here;
		# requesting it elsewhere is a hard configure error
		-DHDF5_ENABLE_DIRECT_VFD=$(usex kernel_linux)
		-DHDF5_ENABLE_PARALLEL=$(usex mpi)
		-DHDF5_ENABLE_SUBFILING_VFD=OFF
		-DHDF5_ENABLE_SZIP_SUPPORT=$(usex szip)
		-DHDF5_ENABLE_ZLIB_SUPPORT=$(usex zlib)
		-DHDF5_USE_ZLIB_NG=OFF
		-DHDF5_ENABLE_THREADSAFE=$(usex threads)
		-DHDF5_ENABLE_CONCURRENCY=OFF
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
		mycmakeargs+=( -DHDF5_H5CC_C_COMPILER=mpicc )
		use cxx && mycmakeargs+=( -DHDF5_H5CC_CXX_COMPILER=mpic++ )
		use fortran && mycmakeargs+=( -DHDF5_H5CC_Fortran_COMPILER=mpif90 )
	else
		mycmakeargs+=( -DHDF5_H5CC_C_COMPILER='${CC:-cc}' )
		use cxx && mycmakeargs+=( -DHDF5_H5CC_CXX_COMPILER='${CXX:-c++}' )
		use fortran &&
			mycmakeargs+=( -DHDF5_H5CC_Fortran_COMPILER='${FC:-gfortran}' )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -r "${ED}/usr/tmp" || die
}
