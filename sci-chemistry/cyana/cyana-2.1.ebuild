# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/cyana/cyana-2.1.ebuild,v 1.13 2015/07/30 18:02:51 jlec Exp $

EAPI=5

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="Combined assignment and dynamics algorithm for NMR applications"
HOMEPAGE="http://www.las.jp/english/products/s08_cyana/index.html"
SRC_URI="${P}.tar.gz"

LICENSE="CYANA"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RESTRICT="fetch"

# we need libg2c for gfortran # 136988
DEPEND="dev-lang/ifc"
RDEPEND="${DEPEND}"

pkg_nofetch() {
	elog "Please visit"
	elog "http://www.las.jp/english/products/cyana.html"
	elog "and get a copy of ${A}."
	elog "Place it in ${DISTDIR}."
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-typo.patch \
		"${FILESDIR}"/${PV}-exec.patch \
		"${FILESDIR}"/${PV}-expire.patch \
		"${FILESDIR}"/${PV}-xiar.patch

	cat >> etc/config <<- EOF
	VERSION=${PV}
	SHELL=${EPREFIX}/bin/sh
	FC=ifort
	FFLAGS=${FFLAGS} -openmp -threads
	FFLAGS2=${FFLAGS} -openmp -threads
	CC=$(tc-getCC)
	AR=xiar
	RANLIB=ranlib
	FORK=g77fork.o
	LDFLAGS=${LDFLAGS} -reentrancy threaded -openmp
	LIBS=
	DEFS=-Dintel
	SYSTEM=intel
	EOF
}

src_compile() {
	cd src || die
	emake
}

src_install() {
	dobin cyana{job,table,filter,clean}
	newbin src/${PN}/${PN}exe.* ${PN}
	insinto /usr/share/${PN}
	doins -r lib macro help
	use examples && doins -r demo

	cat >> "${T}"/20cyana <<- EOF
	CYANALIB="${EPREFIX}/usr/share/${PN}"
	EOF

	doenvd "${T}"/20cyana
}
