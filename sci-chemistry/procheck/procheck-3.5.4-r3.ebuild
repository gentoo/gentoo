# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fortran-2 multilib toolchain-funcs versionator

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
	use doc && elog "manual.tar.gz  ->  ${DISTDIR}/${P}-manual.tar.gz"
}

PATCHES=(
		"${FILESDIR}"/${P}-ldflags.patch
		"${FILESDIR}"/${P}-close.patch
)

src_compile() {
	emake \
		F77=$(tc-getFC) \
		CC=$(tc-getCC) \
		COPTS="${CFLAGS}" \
		FOPTS="${FFLAGS} -std=legacy"
}

src_install() {
	for i in *.scr; do
		newbin ${i} ${i%.scr}
	done

	exeinto /usr/libexec/${PN}/
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

	insinto /usr/libexec/${PN}/
	doins *.dat *.prm
	newins resdefs.dat resdefs.data

	cat >> "${T}"/30${PN} <<- EOF
	prodir="${EPREFIX}/usr/libexec/${PN}/"
	EOF

	doenvd "${T}"/30${PN}

	if use doc; then
		pushd "${WORKDIR}" > /dev/null
			docinto html
			dodoc -r manual
		popd > /dev/null
	fi
}
