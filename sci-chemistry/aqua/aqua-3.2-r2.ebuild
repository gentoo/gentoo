# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="Program suite in this distribution calculates restraint violations"
HOMEPAGE="http://www.biochem.ucl.ac.uk/~roman/procheck/procheck.html"
SRC_URI="
	${PN}${PV}.tar.gz
	doc? ( ${P}-nmr_manual.tar.gz )"

SLOT="0"
LICENSE="procheck"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="sci-chemistry/procheck"
DEPEND=""

RESTRICT="fetch"

S="${WORKDIR}"/${PN}${PV}

pkg_nofetch() {
	elog "Please visit http://www.ebi.ac.uk/thornton-srv/software/PROCHECK/download.html"
	elog "And follow the instruction for downloading ${PN}${PV}.tar.gz ->  ${DISTDIR}/${PN}${PV}.tar.gz."
	if use doc; then
		elog "nmr_manual.tar.gz  ->  ${DISTDIR}/${P}-nmr_manual.tar.gz"
	fi
}

src_prepare() {
	sed \
		-e 's:nawk:gawk:g' \
		-e "s:/bin/gawk:${EPREFIX}/usr/bin/gawk:g" \
		-e "s:/usr/local/bin/perl:${EPREFIX}/usr/bin/perl:g" \
		-i $(find . -type f) || die
	epatch "${FILESDIR}"/${PV}-flags.patch
}

src_compile() {
	pushd src > /dev/null
	emake \
		MYROOT="${WORKDIR}" \
		CC="$(tc-getCC)" \
		FC="$(tc-getFC)" \
		CFLAGS="${CFLAGS} -I../sub/lib" \
		FFLAGS="${FFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		exth
	emake \
		MYROOT="${WORKDIR}" \
		CC="$(tc-getCC)" \
		FC="$(tc-getFC)" \
		CFLAGS="${CFLAGS} -I../sub/lib" \
		FFLAGS="${FFLAGS}" \
		LDFLAGS="${LDFLAGS}"
	popd
}

src_install() {
	rm -f scripts/conv* || die
	dobin bin/* scripts/*
	dosym AquaWhat /usr/bin/qwhat
	dosym AquaHow /usr/bin/qhow
	dosym AquaPseudo /usr/bin/qpseudo
	dosym AquaDist /usr/bin/qdist
	dosym AquaCalc /usr/bin/qcalc
	dosym AquaAssign /usr/bin/qassign
	dosym AquaRedun /usr/bin/qredun
	dosym AquaCompl /usr/bin/qcompl

	dodoc HISTORY HOW_TO_USE NEW README doc/*
	dohtml html/*

	insinto /usr/share/${PN}
	doins data/*
	if use examples; then
		doins -r exmpls
	fi

	if use doc; then
		dohtml -r manual
	fi

	cat >> "${T}"/34aqua <<- EOF
	AQUADATADIR="${EPREFIX}/usr/share/${PN}"
	EOF
	doenvd "${T}"/34aqua
}
