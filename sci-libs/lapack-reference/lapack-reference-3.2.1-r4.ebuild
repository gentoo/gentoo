# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils fortran-2 flag-o-matic multilib toolchain-funcs

MyPN="${PN/-reference/}"
PATCH_V="3.2.1"

DESCRIPTION="FORTRAN reference implementation of LAPACK Linear Algebra PACKage"
HOMEPAGE="http://www.netlib.org/lapack/index.html"
SRC_URI="
	mirror://gentoo/${MyPN}-${PV}.tgz
	mirror://gentoo/${PN}-${PATCH_V}-autotools.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc"

RDEPEND="
	app-eselect/eselect-lapack
	virtual/blas"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/lapack-docs )"

S="${WORKDIR}/${MyPN}-${PV}"

pkg_setup() {
	fortran-2_pkg_setup
	if  [[ $(tc-getFC) =~ if ]]; then
		ewarn "Using Intel Fortran at your own risk"
		export LDFLAGS="$(raw-ldflags)"
		export NOOPT_FFLAGS=-O
	fi
	ESELECT_PROF=reference
}

src_prepare() {
	epatch \
		"${WORKDIR}"/${PN}-${PATCH_V}-autotools.patch \
		"${FILESDIR}"/${P}-parallel-make.patch
	eautoreconf

	# set up the testing routines
	sed \
		-e "s:g77:$(tc-getFC):" \
		-e "s:-funroll-all-loops -O3:${FFLAGS} $($(tc-getPKG_CONFIG) --cflags blas):" \
		-e "s:LOADOPTS =:LOADOPTS = ${LDFLAGS} $($(tc-getPKG_CONFIG) --cflags blas):" \
		-e "s:../../blas\$(PLAT).a:$($(tc-getPKG_CONFIG) --libs blas):" \
		-e "s:lapack\$(PLAT).a:SRC/.libs/liblapack.a:" \
		make.inc.example > make.inc \
		|| die "Failed to set up make.inc"

	cp "${FILESDIR}"/eselect.lapack.reference "${T}"/eselect.lapack.reference || die
	sed -i -e "s:/usr:${EPREFIX}/usr:" "${T}"/eselect.lapack.reference || die
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/\.so\([\.0-9]\+\)\?/\1.dylib/g' \
			"${T}"/eselect.lapack.reference || die
	fi
	sed \
		-e '/Libs:/s|: |: -L${libdir} |g' \
		-i lapack.pc.in || die
}

src_configure() {
	econf \
		--libdir="${EPREFIX}/usr/$(get_libdir)/lapack/reference" \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
}

src_install() {
	default
	eselect lapack add $(get_libdir) "${T}"/eselect.lapack.reference ${ESELECT_PROF}
}

src_test() {
	MAKEOPTS+=" -j1"
	cd "${S}"/TESTING/MATGEN && emake || die
	cd "${S}"/TESTING && emake || die
}

pkg_postinst() {
	local p=lapack
	local current_lib=$(eselect ${p} show | cut -d' ' -f2)
	if [[ ${current_lib} == ${ESELECT_PROF} || -z ${current_lib} ]]; then
		# work around eselect bug #189942
		local configfile="${EROOT}"/etc/env.d/${p}/$(get_libdir)/config
		[[ -e ${configfile} ]] && rm -f ${configfile}
		eselect ${p} set ${ESELECT_PROF}
		elog "${p} has been eselected to ${ESELECT_PROF}"
	else
		elog "Current eselected ${p} is ${current_lib}"
		elog "To use ${p} ${ESELECT_PROF} implementation, you have to issue (as root):"
		elog "\t eselect ${p} set ${ESELECT_PROF}"
	fi
}
