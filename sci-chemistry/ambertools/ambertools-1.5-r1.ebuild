# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="A suite for carrying out complete molecular mechanics investigations"
HOMEPAGE="http://ambermd.org/#AmberTools"
SRC_URI="
	AmberTools-${PV}.tar.bz2
	mirror://gentoo/${P}-bugfix_1-10.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="mpi openmp static-libs X"

RESTRICT="fetch"

RDEPEND="
	virtual/cblas
	virtual/lapack
	sci-libs/clapack
	sci-libs/arpack
	sci-libs/cifparse-obj
	sci-chemistry/mopac7
	sci-libs/netcdf
	sci-libs/fftw:2.1
	sci-chemistry/reduce"
DEPEND="${RDEPEND}
	dev-util/byacc
	dev-libs/libf2c
	sys-devel/ucpp
	virtual/pkgconfig"
S="${WORKDIR}/amber11"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${A}"
	einfo "Place it in ${DISTDIR}"
}

pkg_setup() {
	fortran-2_pkg_setup
	if use openmp; then
		tc-has-openmp || \
			die "Please select an openmp capable compiler like gcc[openmp]"
	fi
	AMBERHOME="${S}"
}

src_prepare() {
	epatch \
		"${WORKDIR}/${P}-bugfix_1-10.patch" \
		"${FILESDIR}/${P}-gentoo.patch"
	cd AmberTools/src
	rm -r arpack blas lapack fftw-2.1.5 c9x-complex cifparse netcdf pnetcdf reduce ucpp-1.3 || die
}

src_configure() {
	cd AmberTools/src
	sed \
		-e "s:\\\\\$(LIBDIR)/arpack.a:-larpack:g" \
		-e "s:\\\\\$(LIBDIR)/lapack.a:$($(tc-getPKG_CONFIG) --libs lapack) -lclapack:g" \
		-e "s:\\\\\$(LIBDIR)/blas.a:$($(tc-getPKG_CONFIG) --libs blas cblas):g" \
		-e "s:\\\\\$(LIBDIR)/libdrfftw.a:${EPREFIX}/usr/$(get_libdir)/libdrfftw.a:g" \
		-e "s:\\\\\$(LIBDIR)/libdfftw.a:${EPREFIX}/usr/$(get_libdir)/libdrfftw.a:g" \
		-e "s:CFLAGS=:CFLAGS=${CFLAGS} -DBINTRAJ :g" \
		-e "s:FFLAGS=:FFLAGS=${FFLAGS} :g" \
		-e "s:LDFLAGS=$ldflags:LDFLAGS=${LDFLAGS}:g" \
		-e "s:fc=g77:fc=$(tc-getFC):g" \
		-e "s:\$netcdflib:$($(tc-getPKG_CONFIG) --libs netcdf):g" \
		-e "s:NETCDF=\$netcdf:NETCDF=netcdf.mod:g" \
		-e "s:-O3::g" \
		-i configure || die
	sed -e "s:arsecond_:arscnd_:g" \
		-i sff/time.c \
		-i sff/sff.h \
		-i sff/sff.c || die
	sed -e "s:\$(NAB):\$(NAB) -lrfftw:g" \
		-i nss/Makefile || die

	local myconf

	use X || myconf="${myconf} -noX11"

	for x in mpi openmp; do
		use ${x} && myconf="${myconf} -${x}"
	done

	./configure \
		${myconf} \
		-nobintraj \
		-nomdgx \
		-nopython \
		-nomtkpp \
		gnu
#	$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')
}

src_compile() {
	cd AmberTools/src
	emake
}

src_install() {
	rm -r bin/chemistry bin/MMPBSA_mods
	rm bin/ante-MMPBSA.py bin/extractFrcmod.py
	for x in bin/*
		do dobin ${x} || die
	done
	rm "${ED}/usr/bin/yacc"
	dobin AmberTools/src/antechamber/mopac.sh
	sed -e "s:\$AMBERHOME/bin/mopac:mopac7:g" \
		-i "${ED}/usr/bin/mopac.sh" || die
	# Make symlinks untill binpath for amber will be fixed
	dodir /usr/share/${PN}/bin
	cd "${ED}/usr/bin"
	for x in *; do
		dosym /usr/bin/${x} /usr/share/${PN}/bin/${x}
	done
	cd "${S}"
#	sed -e "s:\$AMBERHOME/dat:\$AMBERHOME/share/ambertools/dat:g" \
#		-i "${ED}/usr/bin/xleap" \
#		-i "${ED}/usr/bin/tleap" || die
	dodoc doc/AmberTools.pdf doc/leap_pg.pdf

	use static-libs && dolib.a lib/*

	insinto /usr/include/${PN}
	doins include/*

	insinto /usr/share/${PN}
	doins -r dat

	cd AmberTools
	doins -r benchmarks examples test

	cat >> "${T}"/99ambertools <<- EOF
	AMBERHOME="${EPREFIX}/usr/share/ambertools"
	EOF
	doenvd "${T}"/99ambertools
}
