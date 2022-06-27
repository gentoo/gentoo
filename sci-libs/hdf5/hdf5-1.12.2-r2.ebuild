# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED="fortran"

inherit cmake flag-o-matic fortran-2 toolchain-funcs

MY_P="${PN}-${PV/_p/-patch}"
MAJOR_P="${PN}-$(ver_cut 1-2)"

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="https://www.hdfgroup.org/HDF5/"
SRC_URI="https://www.hdfgroup.org/ftp/HDF5/releases/${MAJOR_P}/${MY_P}/src/${MY_P}.tar.bz2"

LICENSE="NCSA-HDF"
SLOT="0/${PV%%_p*}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="cxx debug doc examples fortran +hl mpi szip test threads unsupported zlib"

REQUIRED_USE="
	!unsupported? (
		mpi? ( !cxx !threads )
		threads? ( !cxx !fortran !hl )
	)"

RESTRICT="!test? ( test )"

RDEPEND="
	mpi? ( virtual/mpi[romio] )
	szip? ( virtual/szip )
	zlib? ( sys-libs/zlib:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="doc? (
	app-doc/doxygen
	virtual/latex-base
)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.2-cmake_installdirs.patch
)

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use fortran && fortran-2_pkg_setup

	if use mpi; then
		if has_version 'sci-libs/hdf5[-mpi]'; then
			ewarn "Installing hdf5 with mpi enabled with a previous hdf5 with mpi disabled may fail."
			ewarn "Try to uninstall the current hdf5 prior to enabling mpi support."
		fi
		export CC="mpicc"
		use fortran && export FC="mpif90"
		append-libs -lmpi
	elif has_version 'sci-libs/hdf5[mpi]'; then
		ewarn "Installing hdf5 with mpi disabled while having hdf5 installed with mpi enabled may fail."
		ewarn "Try to uninstall the current hdf5 prior to disabling mpi support."
	fi
}

src_configure() {
	use sparc && tc-is-gcc && append-flags -fno-tree-ccp # bug 686620
	local mycmakeargs=(
		# Workaround needed to allow build with USE=fortran when an older
		# version is installed. See bug #808633 and
		# https://github.com/HDFGroup/hdf5/issues/1027 upstream.
		-DCMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE=ON
		-DBUILD_STATIC_LIBS=OFF
		-DONLY_SHARED_LIBS=ON
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DHDF5_BUILD_EXAMPLES=OFF
		-DH5_DEFAULT_PLUGINDIR="${EPREFIX}/usr/$(get_libdir)/hdf5/plugin"
		-DALLOW_UNSUPPORTED=$(usex unsupported)
		-DBUILD_TESTING=$(usex test)
		-DHDF5_BUILD_CPP_LIB=$(usex cxx)
		-DHDF5_BUILD_DOC=$(usex doc)
		-DHDF5_BUILD_FORTRAN=$(usex fortran)
		-DHDF5_BUILD_HL_LIB=$(usex hl)
		-DHDF5_ENABLE_CODESTACK=$(usex debug)
		-DHDF5_ENABLE_PARALLEL=$(usex mpi)
		-DHDF5_ENABLE_SZIP_ENCODING=$(usex szip)
		-DHDF5_ENABLE_SZIP_SUPPORT=$(usex szip)
		-DHDF5_ENABLE_THREADSAFE=$(usex threads)
		-DHDF5_ENABLE_Z_LIB_SUPPORT=$(usex zlib)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# TODO: generate functioning example runners from their respective
	# .in files - as of version 1.12.1 upstream only has it implemented
	# for autoconf.
	if use examples; then
		# These are all useless outside the source tree
		rm -f {examples,c++/examples,fortran/examples}/{Makefile*,CMake*}
		rm -f hl/{examples,c++/examples,fortran/examples}/{Makefile*,CMake*}

		dodoc -r examples
		if use cxx; then
			docinto c++
			dodoc -r c++/examples
		fi
		if use fortran; then
			docinto fortran
			dodoc -r fortran/examples
		fi
		if use hl; then
			docinto hl
			dodoc -r hl/examples
			if use cxx; then
				docinto hl/c++
				dodoc -r hl/c++/examples
			fi
			if use fortran; then
				docinto hl/fortran
				dodoc -r hl/fortran/examples
			fi
		fi
	fi
}
