# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED="fortran"
FORTRAN_STANDARD="90 2003"

inherit cmake flag-o-matic fortran-2

DESCRIPTION="CFD General Notation System standard library"
HOMEPAGE="
	https://cgns.github.io/
	https://github.com/CGNS/CGNS
"
SRC_URI="https://github.com/CGNS/CGNS/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CGNS-${PV}"

LICENSE="ZLIB"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="base-scope debug examples fortran hdf5 legacy mpi scoping szip test tools"

RDEPEND="
	hdf5? ( sci-libs/hdf5:=[mpi=,szip=] )
	tools? (
		dev-lang/tcl:=
		dev-lang/tk:=
		x11-libs/libXmu:=
		virtual/glu
		virtual/opengl
	)
"
DEPEND="${RDEPEND}"

RESTRICT="
	fortran? ( test )
	!test? ( test )
"
REQUIRED_USE="
	mpi? ( hdf5 )
	szip? ( hdf5 )
"

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	# gentoo libdir
	sed \
		-e 's|/lib|/'$(get_libdir)'|' \
		-e '/DESTINATION/s|lib|'$(get_libdir)'|g' \
		-i src/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862684
	# https://github.com/CGNS/CGNS/issues/758
	filter-lto

	local mycmakeargs=(
		-DCGNS_BUILD_SHARED=ON
		-DCGNS_USE_SHARED=ON

		-DCGNS_BUILD_CGNSTOOLS="$(usex tools)"
		-DCGNS_ENABLE_BASE_SCOPE="$(usex base-scope)"
		-DCGNS_ENABLE_FORTRAN="$(usex fortran)"
		-DCGNS_ENABLE_HDF5="$(usex hdf5)"
		-DCGNS_ENABLE_LEGACY="$(usex legacy)"
		-DCGNS_ENABLE_SCOPING="$(usex scoping)"
		-DCGNS_ENABLE_MEM_DEBUG="$(usex debug)"
		-DCGNS_ENABLE_TESTS="$(usex test)"
	)

	if use mpi; then
		mycmakeargs+=(
			-DHDF5_NEED_MPI="$(usex mpi)"
			-DHDF5_NEED_SZIP="$(usex szip)"
			-DHDF5_NEED_ZLIB="$(usex szip)"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc README.md release_docs/{HISTORY,RELEASE,changes_from_2.5}.txt
	rm "${ED}/usr/$(get_libdir)/libcgns.a" || die
	dodoc release_docs/*.pdf
	docompress -x /usr/share/doc/${PF}/examples
	use examples && dodoc -r src/examples
}
