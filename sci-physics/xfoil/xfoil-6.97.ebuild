# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils fortran-2

DESCRIPTION="Design and analysis of subsonic isolated airfoils"
HOMEPAGE="http://raphael.mit.edu/xfoil/"
SRC_URI="
	http://web.mit.edu/drela/Public/web/${PN}/${PN}${PV}.tar.gz
	doc? ( http://web.mit.edu/drela/Public/web/${PN}/dataflow.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

S="${WORKDIR}/Xfoil"

src_prepare() {
	sed \
		-e '/^FC/d' \
		-e '/^CC/d' \
		-e '/^FFLAGS/d' \
		-e '/^CFLAGS/d' \
		-e 's/^\(FFLOPT .*\)/FFLOPT = $(FFLAGS)/g' \
		-i {bin,plotlib,orrs/bin}/Makefile plotlib/config.make \
		|| die "sed for flags and compilers failed"

	# fix bug #147033
	[[ $(tc-getFC) == *gfortran ]] && \
		epatch "${FILESDIR}"/${PN}-6.96-gfortran.patch

	epatch "${FILESDIR}"/${P}-overflow.patch

	sed \
		-e "s:/var/local/codes/orrs/osmap.dat:${EPREFIX}/usr/share/xfoil/orrs/osmap.dat:" \
		-i orrs/src/osmap.f || die "sed osmap.f failed"
}

src_compile() {
	cd "${S}"/orrs/bin
	emake FLG="${FFLAGS}" FTNLIB="${LDFLAGS}" OS
	cd "${S}"/orrs
	bin/osgen osmaps_ns.lst
	cd "${S}"/plotlib
	emake CFLAGS="${CFLAGS} -DUNDERSCORE"
	cd "${S}"/bin
	for i in xfoil pplot pxplot; do
		emake \
			PLTOBJ="../plotlib/libPlt.a" \
			CFLAGS="${CFLAGS} -DUNDERSCORE" \
			FTNLIB="${LDFLAGS}" \
			${i}
	done
}

src_install() {
	dobin bin/pplot bin/pxplot bin/xfoil
	insinto /usr/share/xfoil/orrs
	doins orrs/osm*.dat
	dodoc *.txt README
	insinto /usr/share/doc/${PF}/
	use examples && doins -r runs
	use doc && dodoc "${DISTDIR}"/dataflow.pdf
}
