# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Mixed Integer Linear Programming (MILP) solver"
HOMEPAGE="https://sourceforge.net/projects/lpsolve/"
SRC_URI="mirror://sourceforge/${PN}/lp_solve_${PV}_source.tar.gz"
S="${WORKDIR}"/lp_solve_$(ver_cut 1-2)

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="sci-libs/colamd"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.5.2.11-misc.patch
)

src_compile() {
	tc-export AR CC RANLIB LD

	cd lpsolve55 || die
	sh -x ccc || die

	rm bin/ux*/liblpsolve55.a || die

	cd ../lp_solve || die
	sh -x ccc || die
}

src_install() {
	einstalldocs

	dobin lp_solve/bin/ux*/lp_solve
	dolib.so lpsolve55/bin/ux*/liblpsolve55.so

	insinto /usr/include/lpsolve
	doins *.h
}
