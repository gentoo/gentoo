# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/solve-resolve-bin/solve-resolve-bin-2.13.ebuild,v 1.5 2015/01/09 08:11:22 jlec Exp $

EAPI=5

inherit eutils

DESCRIPTION="Automated crystallographic structure solution for MIR, SAD, and MAD"
HOMEPAGE="http://www.solve.lanl.gov/index.html"
SRC_URI="
	x86? ( https://solve.lanl.gov/pub/solve/${PV}/solve-${PV}-linux.tar.gz )
	amd64? ( https://solve.lanl.gov/pub/solve/${PV}/solve-${PV}-linux-64.tar.gz )"

SLOT="0"
LICENSE="solve"
KEYWORDS="-* x86 amd64"
IUSE="examples"

RDEPEND="sci-libs/ccp4-libs"
DEPEND=""

RESTRICT="mirror"

S="${WORKDIR}"/solve-${PV}

QA_PREBUILT="opt/solve-resolve/bin/*"

src_install(){
	local IN_PATH="/opt/solve-resolve/"

	exeinto ${IN_PATH}bin/
	doexe bin/*

	insinto ${IN_PATH}lib/
	doins -r lib/{*sym,sym*,hist*,*dat,segments,patterns}

	docinto html
	dodoc -r lib/html/*

	sed \
		-e 's:/usr/local/lib/solve/:${EPREFIX}/opt/solve-resolve/lib/:' \
		-i lib/examples_solve/p9/solve* || die
	if use examples; then
		sed \
			-e 's:/usr/local/lib/resolve/:${EPREFIX}/opt/solve-resolve/lib/:' \
			-i lib/examples_resolve/{resolve.csh,prime_and_switch.csh} || die
		insinto /usr/share/${PF}/
		doins -r lib/examples_*solve
	fi

	cat >> "${T}"/20solve-resolve <<- EOF
	CCP4_OPEN="UNKNOWN"
	SYMOP="${EPREFIX}/usr/share/ccp4/data/symop.lib"
	SYMINFO="${EPREFIX}/usr/share/ccp4/data/syminfo.lib"
	SOLVEDIR="${EPREFIX}/${IN_PATH}lib/"
	PATH="${EPREFIX}/${IN_PATH}bin"
	EOF

	doenvd "${T}"/20solve-resolve
}

pkg_postinst(){
	einfo "Get a valid license key from"
	einfo "http://solve.lanl.gov/license.html"
	einfo "and place it in"
	einfo "${EPREFIX}${IN_PATH}lib/"
}
