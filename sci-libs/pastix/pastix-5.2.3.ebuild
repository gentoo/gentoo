# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fortran-2 toolchain-funcs

# TODO:
# testing: emake examples?
# better doc instalation and building
# pypastix (separate package?)
# multilib with eselect?
# static libs building without pic
# metis?

# package id: change every version, see the link on inriaforge
PID=218
DESCRIPTION="Parallel solver for very large sparse linear systems"
HOMEPAGE="http://pastix.gforge.inria.fr"
SRC_URI="https://gforge.inria.fr/frs/download.php/latestfile/${PID}/${PN}_${PV}.tar.bz2"

LICENSE="CeCILL-C"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc int64 mpi +smp starpu static-libs"

RDEPEND="
	sci-libs/scotch:0=[int64?,mpi?]
	sys-apps/hwloc:0=
	virtual/blas
	mpi? ( virtual/mpi )
	starpu? ( dev-libs/starpu:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}_${PV}/src"

src_prepare() {
	default
	sed -e 's/^\(HOSTARCH\s*=\).*/\1 ${HOST}/' \
		-e "s:^\(CCPROG\s*=\).*:\1 $(tc-getCC):" \
		-e "s:^\(CFPROG\s*=\).*:\1 $(tc-getFC):" \
		-e "s:^\(CF90PROG\s*=\).*:\1 $(tc-getFC):" \
		-e "s:^\(ARPROG\s*=\).*:\1 $(tc-getAR):" \
		-e "s:^\(CCFOPT\s*=\).*:\1 ${FFLAGS}:" \
		-e "s:^\(CCFDEB\s*=\).*:\1 ${FFLAGS}:" \
		-e 's:^\(EXTRALIB\s*=\).*:\1 -lm -lrt:' \
		-e "s:^#\s*\(ROOT\s*=\).*:\1 \$(DESTDIR)${EPREFIX%/}/usr:" \
		-e 's:^#\s*\(INCLUDEDIR\s*=\).*:\1 $(ROOT)/include:' \
		-e 's:^#\s*\(BINDIR\s*=\).*:\1 $(ROOT)/bin:' \
		-e "s:^#\s*\(LIBDIR\s*=\).*:\1 \$(ROOT)/$(get_libdir):" \
		-e 's:^#\s*\(SHARED\s*=\).*:\1 1:' \
		-e 's:^#\s*\(SOEXT\s*=\).*:\1 .so:' \
		-e '/fPIC/s/^#//g' \
		-e "s:^#\s*\(SHARED_FLAGS\s*=.*\):\1 ${LDFLAGS}:" \
		-e "s:pkg-config:$(tc-getPKG_CONFIG):g" \
		-e "s:^\(BLASLIB\s*=\).*:\1 $($(tc-getPKG_CONFIG) --libs blas):" \
		-e "s:^\s*\(HWLOC_HOME\s*?=\).*:\1 ${EPREFIX}/usr:" \
		-e "s:-I\$(HWLOC_INC):$($(tc-getPKG_CONFIG) --cflags hwloc):" \
		-e "s:-L\$(HWLOC_LIB) -lhwloc:$($(tc-getPKG_CONFIG) --libs hwloc):" \
		-e "s:^\s*\(SCOTCH_HOME\s*?=\).*:\1 ${EPREFIX}/usr:" \
		-e "s:^\s*\(SCOTCH_INC\s*?=.*\):\1/scotch:" \
		-e "s:^\s*\(SCOTCH_LIB\s*?=.*\)lib:\1$(get_libdir):" \
		config/LINUX-GNU.in > config.in || die
	sed -e 's/__SO_NAME__,$@/__SO_NAME__,$(notdir $@)/g' -i Makefile || die
}

src_configure() {
	if use amd64; then
		sed -e 's/^\(VERSIONBIT\s*=\).*/\1 _64bit/' \
			-i config.in || die
	fi

	if use int64; then
		sed -e '/VERSIONINT.*_int64/s/#//' \
			-e '/CCTYPES.*INTSSIZE64/s/#//' \
			-i config.in || die
	fi

	if ! use mpi; then
		sed -e '/VERSIONMPI.*_nompi/s/#//' \
			-e '/CCTYPES.*NOMPI/s/#//' \
			-e '/MPCCPROG\s*= $(CCPROG)/s/#//' \
			-e '/MCFPROG\s*= $(CFPROG)/s/#//' \
			-e 's/-DDISTRIBUTED//' \
			-e 's/-lptscotch/-lscotch/g' \
			-i config.in || die
	fi

	if ! use smp; then
		sed -e '/VERSIONSMP.*_nosmp/s/#//' \
			-e '/CCTYPES.*NOSMP/s/#//' \
			-i config.in || die
	fi

	if use starpu; then
		sed -e '/libstarpu/s/#//g' -i config.in || die
	fi
}

src_compile() {
	emake all drivers
}

src_test() {
	# both test and tests targets are defined and do not work
	emake examples
	echo
}

src_install() {
	default
	sed -e "s:${D}::g" -i "${ED}"/usr/bin/pastix-conf || die
	# quick and dirty (static libs should really be built without pic)
	cd .. || die
	dodoc README.txt doc/refcard/refcard.pdf
}
