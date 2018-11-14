# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

FORTRAN_NEEDED=fortran
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils eutils fortran-2 flag-o-matic toolchain-funcs multilib

MY_P=${PN}-${PV/_p/-patch}

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="http://www.hdfgroup.org/HDF5/"
#SRC_URI="https://support.hdfgroup.org/ftp/HDF5/releases/${MY_P}/src/${MY_P}.tar.bz2"
# TODO: return to proper SRC_URI once upstream fixes their release
SRC_URI="https://support.hdfgroup.org/ftp/HDF5/current18/src/${MY_P}.tar.bz2"

LICENSE="NCSA-HDF"
SLOT="0/${PV%%_p*}"
KEYWORDS="alpha amd64 ~arm ~arm64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cxx debug examples fortran fortran2003 +hl mpi static-libs szip threads zlib"

REQUIRED_USE="
	threads? ( !cxx !mpi !fortran !hl )
	fortran2003? ( fortran )"

RDEPEND="
	mpi? ( virtual/mpi[romio] )
	szip? ( virtual/szip )
	zlib? ( sys-libs/zlib:0= )"

DEPEND="${RDEPEND}
	sys-devel/libtool:2
	>=sys-devel/autoconf-2.69"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.9-static_libgfortran.patch
	"${FILESDIR}"/${PN}-1.8.9-mpicxx.patch
	"${FILESDIR}"/${PN}-1.8.13-no-messing-ldpath.patch
	"${FILESDIR}"/${PN}-1.8.15-implicits.patch
)

pkg_setup() {
	tc-export CXX CC AR # workaround for bug 285148
	if use fortran; then
		use fortran2003 && FORTRAN_STANDARD=2003
		fortran-2_pkg_setup
	fi
	if use mpi; then
		if has_version 'sci-libs/hdf5[-mpi]'; then
			ewarn "Installing hdf5 with mpi enabled with a previous hdf5 with mpi disabled may fail."
			ewarn "Try to uninstall the current hdf5 prior to enabling mpi support."
		fi
		export CC=mpicc
		use fortran && export FC=mpif90
		if use cxx ; then
			export CXX=mpicxx
			ewarn "USE='mpi cxx' requires a configuration unsupported by upstream. Use at your own risk."
			ewarn "In particular, the C++ API is not parallel safe."
		fi
	elif has_version 'sci-libs/hdf5[mpi]'; then
		ewarn "Installing hdf5 with mpi disabled while having hdf5 installed with mpi enabled may fail."
		ewarn "Try to uninstall the current hdf5 prior to disabling mpi support."
	fi
}

src_prepare() {
	# respect gentoo examples directory
	sed \
		-e "s:hdf5_examples:doc/${PF}/examples:g" \
		-i $(find . -name Makefile.am) $(find . -name "run*.sh.in") || die
	sed \
		-e '/docdir/d' \
		-i config/commence.am || die
	if ! use examples; then
		sed -e '/^install:/ s/install-examples//' \
			-i Makefile.am || die #409091
	fi
	# enable shared libs by default for h5cc config utility
	sed -i -e "s/SHLIB:-no/SHLIB:-yes/g" tools/misc/h5cc.in	|| die
	# bug #419677
	use prefix && \
		append-ldflags -Wl,-rpath,"${EPREFIX}"/usr/$(get_libdir) \
		-Wl,-rpath,"${EPREFIX}"/$(get_libdir)
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-production
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--enable-deprecated-symbols
		$(use_enable prefix sharedlib-rpath)
		$(use_enable debug debug all)
		$(use_enable debug codestack)
		$(use_enable cxx)
		$(use_enable fortran)
		$(use_enable fortran2003)
		$(use_enable hl)
		$(use_enable mpi parallel)
		$(use_enable threads threadsafe)
		$(use_with szip szlib)
		$(use_with threads pthread)
		$(use_with zlib)
		$(use mpi && use cxx && echo --enable-unsupported)
	)
	autotools-utils_src_configure
}
