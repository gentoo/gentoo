# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran

# We've reverted *back* to autotools from CMake because of
# https://github.com/HDFGroup/hdf5/issues/1814.
inherit autotools fortran-2 flag-o-matic toolchain-funcs prefix

MY_P=${PN}-${PV/_p/-patch}
MAJOR_P=${PN}-$(ver_cut 1-2)

DESCRIPTION="General purpose library and file format for storing scientific data"
HOMEPAGE="https://www.hdfgroup.org/HDF5/"
SRC_URI="https://www.hdfgroup.org/ftp/HDF5/releases/${MAJOR_P}/${MY_P}/src/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="NCSA-HDF"
SLOT="0/${PV%%_p*}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="cxx debug examples fortran +hl mpi szip test threads unsupported zlib"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	!unsupported? (
		cxx? ( !mpi ) mpi? ( !cxx )
		threads? ( !cxx !mpi !fortran !hl )
	)
"

RDEPEND="
	mpi? ( virtual/mpi[romio] )
	szip? ( virtual/szip )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/hdf5-1.14.2-0001-Make-sure-that-during-runtime-we-ll-use-the-same-lib.patch
	"${FILESDIR}"/hdf5-1.14.2-0002-Disable-forced-stripping.patch
	"${FILESDIR}"/hdf5-1.14.2-0003-Drop-broken-Werror-stripping.patch
)

pkg_setup() {
	# Workaround for bug 285148
	tc-export CXX CC AR

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

src_prepare() {
	default

	# Respect Gentoo examples directory
	sed \
		-e "s:hdf5_examples:doc/${PF}/examples:g" \
		-i $(find . -name Makefile.am) $(find . -name "run*.sh.in") || die
	sed \
		-e '/docdir/d' \
		-i config/commence.am || die

	if ! use examples; then
		# bug #409091
		sed -e '/^install:/ s/install-examples//' \
			-i Makefile.am || die
	fi

	# Enable shared libs by default for h5cc config utility
	sed -i -e "s/SHLIB:-no/SHLIB:-yes/g" bin/h5cc.in || die
	hprefixify m4/libtool.m4

	eautoreconf
}

src_configure() {
	# bug #686620
	use sparc && tc-is-gcc && append-flags -fno-tree-ccp

	econf \
		--disable-static \
		--enable-deprecated-symbols \
		--enable-build-mode=$(usex debug debug production) \
		--with-default-plugindir="${EPREFIX}/usr/$(get_libdir)/${PN}/plugin" \
		$(use_enable cxx) \
		$(use_enable debug codestack) \
		$(use_enable fortran) \
		$(use_enable hl) \
		$(use_enable mpi parallel) \
		$(use_enable test tests) \
		$(use_enable threads threadsafe) \
		$(use_enable unsupported) \
		$(use_with szip szlib) \
		$(use_with threads pthread) \
		$(use_with zlib)
}

src_install() {
	emake DESTDIR="${D}" EPREFIX="${EPREFIX}" install

	# No static archives
	find "${ED}" -name '*.la' -delete || die
}
