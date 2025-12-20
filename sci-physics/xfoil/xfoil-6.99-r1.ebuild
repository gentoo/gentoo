# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 flag-o-matic toolchain-funcs

DESCRIPTION="Design and analysis of subsonic isolated airfoils"
HOMEPAGE="https://web.mit.edu/drela/Public/web/xfoil/"
SRC_URI="
	https://web.mit.edu/drela/Public/web/${PN}/${PN}${PV}.tgz
	doc? ( https://web.mit.edu/drela/Public/web/${PN}/dataflow.pdf )"
S="${WORKDIR}/${PN^}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-overflow.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	# fix bug #147033
	[[ $(tc-getFC) == *gfortran ]] && PATCHES+=( "${FILESDIR}"/${PN}-6.96-gfortran.patch )
	default

	# GCC 10 workaround
	# bug #722194
	append-fflags $(test-flags-FC -fallow-argument-mismatch)

	sed \
		-e '/^FC/d' \
		-e '/^CC/d' \
		-e '/^FFLAGS/d' \
		-e '/^CFLAGS/d' \
		-e '/INSTALLCMD/d' \
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
	bin/osgen osmaps_ns.lst || die
	popd >/dev/null || die
	emake -C plotlib \
		CFLAGS="${CFLAGS} -DUNDERSCORE" \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR) r" \
		RANLIB="$(tc-getRANLIB)"

	local i
	for i in blu pplot pxplot xfoil; do
		emake -C bin \
			PLTOBJ="../plotlib/libPlt_gSP.a" \
			CFLAGS="${CFLAGS} -DUNDERSCORE" \
			FTNLIB="${LDFLAGS}" \
			CC="$(tc-getCC)" \
			AR="$(tc-getAR) r" \
			RANLIB="$(tc-getRANLIB)" \
			$i
	done
}

src_install() {
	dobin bin/{blu,pplot,pxplot,xfoil}
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
