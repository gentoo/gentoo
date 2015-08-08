# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools eutils fortran-2 flag-o-matic multilib toolchain-funcs

MyPN="${PN/-reference/}"

DESCRIPTION="FORTRAN reference implementation of LAPACK Linear Algebra PACKage"
HOMEPAGE="http://www.netlib.org/lapack/index.html"
SRC_URI="
	http://www.netlib.org/lapack/${MyPN}-lite-${PV}.tgz
	mirror://gentoo/${P}-autotools.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="
	app-eselect/eselect-lapack
	virtual/blas"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/lapack-docs )"

S="${WORKDIR}/${MyPN}-lite-${PV}"

pkg_setup() {
	fortran-2_pkg_setup
	if  [[ $(tc-getFC) =~ if ]]; then
		ewarn "Using Intel Fortran at your own risk"
		export LDFLAGS="$(raw-ldflags)"
		export NOOPT_FFLAGS=-O
	fi
	ESELECT_PROF=reference
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${P}-autotools.patch
	epatch "${FILESDIR}"/${P}-test-fix.patch
	eautoreconf

	# set up the testing routines
	sed -e "s:g77:$(tc-getFC):" \
		-e "s:-funroll-all-loops -O3:${FFLAGS} $($(tc-getPKG_CONFIG) --cflags blas):" \
		-e "s:LOADOPTS =:LOADOPTS = ${LDFLAGS} $($(tc-getPKG_CONFIG) --cflags blas):" \
		-e "s:../../blas\$(PLAT).a:$($(tc-getPKG_CONFIG) --libs blas):" \
		-e "s:lapack\$(PLAT).a:SRC/.libs/liblapack.a:" \
		make.inc.example > make.inc \
		|| die "Failed to set up make.inc"
}

src_compile() {
	econf \
		--libdir="/usr/$(get_libdir)/lapack/reference" \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README || die "dodoc failed"
	eselect lapack add $(get_libdir) "${FILESDIR}"/eselect.lapack.reference ${ESELECT_PROF}
}

src_test() {
	cd "${S}"/TESTING/MATGEN
	emake || die "Failed to create tmglib.a"
	cd "${S}"/TESTING
	emake || die "lapack-reference tests failed."
}

pkg_postinst() {
	local p=lapack
	local current_lib=$(eselect ${p} show | cut -d' ' -f2)
	if [[ ${current_lib} == ${ESELECT_PROF} || -z ${current_lib} ]]; then
		# work around eselect bug #189942
		local configfile="${ROOT}"/etc/env.d/${p}/$(get_libdir)/config
		[[ -e ${configfile} ]] && rm -f ${configfile}
		eselect ${p} set ${ESELECT_PROF}
		elog "${p} has been eselected to ${ESELECT_PROF}"
	else
		elog "Current eselected ${p} is ${current_lib}"
		elog "To use ${p} ${ESELECT_PROF} implementation, you have to issue (as root):"
		elog "\t eselect ${p} set ${ESELECT_PROF}"
	fi
}
