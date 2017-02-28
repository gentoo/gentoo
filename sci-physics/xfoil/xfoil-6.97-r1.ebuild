# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fortran-2

DESCRIPTION="Design and analysis of subsonic isolated airfoils"
HOMEPAGE="http://raphael.mit.edu/xfoil/"
SRC_URI="
	http://web.mit.edu/drela/Public/web/${PN}/${PN}${PV}.tar.gz
	doc? ( http://web.mit.edu/drela/Public/web/${PN}/dataflow.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-overflow.patch )

S="${WORKDIR}/${PN^}"

src_prepare() {
	# fix bug #147033
	[[ $(tc-getFC) == *gfortran ]] && PATCHES+=( "${FILESDIR}"/${PN}-6.96-gfortran.patch )
	default

	sed \
		-e '/^FC/d' \
		-e '/^CC/d' \
		-e '/^FFLAGS/d' \
		-e '/^CFLAGS/d' \
		-e 's/^\(FFLOPT .*\)/FFLOPT = $(FFLAGS)/g' \
		-i {bin,plotlib,orrs/bin}/Makefile plotlib/config.make \
		|| die "sed for flags and compilers failed"

	sed \
		-e "s:/var/local/codes/orrs/osmap.dat:${EPREFIX}/usr/share/xfoil/orrs/osmap.dat:" \
		-i orrs/src/osmap.f || die "sed osmap.f failed"
}

src_compile() {
	emake -C orrs/bin FLG="${FFLAGS}" FTNLIB="${LDFLAGS}" OS
	pushd orrs >/dev/null || die
	bin/osgen osmaps_ns.lst
	popd >/dev/null || die
	emake -C plotlib CFLAGS="${CFLAGS} -DUNDERSCORE"

	local i
	for i in xfoil pplot pxplot; do
		emake -C bin \
			PLTOBJ="../plotlib/libPlt.a" \
			CFLAGS="${CFLAGS} -DUNDERSCORE" \
			FTNLIB="${LDFLAGS}" \
			$i
	done
}

src_install() {
	dobin bin/{pplot,pxplot,xfoil}
	insinto /usr/share/xfoil/orrs
	doins orrs/osm*.dat

	local DOCS=( *.txt README )
	use doc && DOCS+=( "${DISTDIR}"/dataflow.pdf )
	einstalldocs
	if use examples; then
		dodoc -r runs
		docompress -x /usr/share/doc/${PF}/runs
	fi
}
