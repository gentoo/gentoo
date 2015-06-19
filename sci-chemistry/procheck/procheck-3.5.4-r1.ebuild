# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/procheck/procheck-3.5.4-r1.ebuild,v 1.7 2012/10/19 10:20:35 jlec Exp $

EAPI=4

inherit eutils fortran-2 multilib toolchain-funcs versionator

DESCRIPTION="Checks the stereochemical quality of a protein structure"
HOMEPAGE="http://www.biochem.ucl.ac.uk/~roman/procheck/procheck.html"
SRC_URI="
	${P}.tar.gz ${P}-README
	doc? ( ${P}-manual.tar.gz )"

LICENSE="procheck"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="app-shells/tcsh"
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S="${WORKDIR}/${PN}"

pkg_nofetch() {
	elog "Please visit http://www.ebi.ac.uk/thornton-srv/software/PROCHECK/download.html"
	elog "And follow the instruction for downloading."
	elog "Files should be stored in following way"
	elog "${PN}.tar.gz  ->  ${DISTDIR}/${P}.tar.gz"
	elog "README  ->  ${DISTDIR}/${P}-README"
	if use doc; then
		elog "manual.tar.gz  ->  ${DISTDIR}/${P}-manual.tar.gz"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-ldflags.patch
}

src_compile() {
	emake \
		F77=$(tc-getFC) \
		CC=$(tc-getCC) \
		COPTS="${CFLAGS}" \
		FOPTS="${FFLAGS}"
}

src_install() {
	for i in *.scr; do
		newbin ${i} ${i%.scr}
	done

	exeinto /usr/$(get_libdir)/${PN}/
	doexe \
		anglen \
		clean \
		rmsdev \
		secstr \
		gfac2pdb \
		pplot \
		bplot \
		tplot \
		mplot \
		vplot \
		viol2pdb \
		wirplot \
		nb
	dodoc "${DISTDIR}"/${P}-README

	insinto /usr/$(get_libdir)/${PN}/
	doins *.dat *.prm
	newins resdefs.dat resdefs.data

	cat >> "${T}"/30${PN} <<- EOF
	prodir="${EPREFIX}/usr/$(get_libdir)/${PN}/"
	EOF

	doenvd "${T}"/30${PN}

	if use doc; then
		pushd "${WORKDIR}"
			dohtml -r manual
		popd
	fi
}
