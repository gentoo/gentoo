# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cblas-reference/cblas-reference-20030223-r5.ebuild,v 1.11 2015/03/31 20:14:22 ulm Exp $

EAPI="3"

inherit autotools eutils fortran-2 multilib toolchain-funcs

MyPN="${PN/-reference/}"

DESCRIPTION="C wrapper interface to the F77 reference BLAS implementation"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://www.netlib.org/blas/blast-forum/${MyPN}.tgz"

SLOT="0"
LICENSE="public-domain"
IUSE=""
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	virtual/blas
	app-eselect/eselect-cblas"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

ESELECT_PROF=reference
S="${WORKDIR}/CBLAS"

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotool.patch
	eautoreconf

	cp "${FILESDIR}"/eselect.cblas.reference "${T}"/
	sed -i -e "s:/usr:${EPREFIX}/usr:" "${T}"/eselect.cblas.reference || die
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -i -e 's/\.so\([\.0-9]\+\)\?/\1.dylib/g' \
			"${T}"/eselect.cblas.reference || die
	fi
}

src_configure() {
	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/blas/reference \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README || die "failed to install docs"
	insinto /usr/share/doc/${PF}
	doins cblas_example*c || die "install examples failed"
	eselect cblas add $(get_libdir) "${T}"/eselect.cblas.reference ${ESELECT_PROF}
}

pkg_postinst() {
	local p=cblas
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
