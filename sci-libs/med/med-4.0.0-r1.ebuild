# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit autotools flag-o-matic fortran-2 python-single-r1

#DESCRIPTION="A library to store and exchange meshed data or computation results"
DESCRIPTION="Modeling and Exchange of Data library"
HOMEPAGE="https://www.salome-platform.org/user-section/about/med"
SRC_URI="https://files.salome-platform.org/Salome/other/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fortran hdf5-16-api python test"

# fails to run parallel tests
RESTRICT="test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# dev-lang/tk is needed for wish-based xmdump utility
RDEPEND="
	!sci-libs/libmed
	dev-lang/tk:0=
	>=sci-libs/hdf5-1.10.2:=[fortran=,mpi(+)]
	virtual/mpi[fortran=]
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="python? ( >=dev-lang/swig-3.0.8 )"

PATCHES=(
	"${FILESDIR}/${P}-0001-doc-html.doc-Makefile.am-install-into-htmldir.patch"
)

DOCS=( AUTHORS ChangeLog README )

pkg_setup() {
	use python && python-single-r1_pkg_setup
	use fortran && fortran-2_pkg_setup
}

src_prepare() {
	if use hdf5-16-api; then
		append-cppflags -DH5_USE_16_API
	fi

	# add flag to produce python 3 code
	sed -e 's|SWIG_PYTHON_OPT += -c++|SWIG_PYTHON_OPT += -c++ -relativeimport -py3|' \
		-i ./python/Makefile.am || die "failed to change swig options"

	# don't use version information when linking python libraries
	sed -e 's|= -module|= -avoid-version -module|' \
		-i ./python/Makefile.am || die "failed to change python link flags"

	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-api23
		--disable-installtest
		--disable-static
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html
		--with-hdf5="${EPREFIX}"/usr
		--with-hdf5-lib="${EPREFIX}"/usr/$(get_libdir)
		$(use_enable fortran)
		$(use_enable python)
	)

	if ! use fortran; then
		myconf+=(
			--with-f90=no
		)
	fi

	if use python; then
		myconf+=(
			--with-swig="${EPREFIX}/usr"
		)
	fi

	export MPICC=mpicc
	export MPICXX=mpicxx
	export MPIFC=mpif90
	export MPIF77=mpif77
	export FC=mpif90
	export F77=mpif77

	econf "${myconf[@]}"
}

src_install() {
	use python && python_optimize

	default

	find "${ED}/usr/$(get_libdir)" -type f -name '*.la' -delete || die "failed to delete *.la files"

	# remove unnecessary doc subdirs
	rm -r "${ED}"/usr/share/doc/${PF}/{gif,jpg,odt,png} || die "failed to remove unneeded doc subdirs"
	if ! use doc; then
		rm -r "${ED}"/usr/share/doc/${PF}/html || die "failed to remove html documentation"
	fi

	# Prevent test executables being installed
	if use test; then
		rm -r "${ED}"/usr/bin/{testc,testf,testpy} || die "failed to delete test executables"
	fi

	# we don't need old 2.3.6 include files
	rm -r "${ED}"/usr/include/2.3.6 || die "failed to delete obsolete include dir"

	rm "${ED}"/usr/$(get_libdir)/libmed3.settings || die "failed to remove libmed3.settings"
}
