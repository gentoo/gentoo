# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Mixed Integer Linear Programming (MILP) solver"
HOMEPAGE="https://github.com/lp-solve/lp_solve/"
SRC_URI="https://github.com/lp-solve/lp_solve/releases/download/${PV}/lp_solve_${PV}_source.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/lp_solve"

LICENSE="LGPL-2.1"
SLOT="0/55"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}"/5.5.2.14-ldflags.patch
	"${FILESDIR}"/5.5.2.14-tc-direct.patch
)

src_prepare() {
	default

	# remove hardcoded -O3
	sed -i "s/'-O3'/'${CFLAGS}'/g" $(find . -name ccc) || die

	# verify subslot against soname (bug #614866)
	local actual_soname=$(grep -iEo -- "-soname,liblpsolve([A-z0-9]+)" lpsolve*/ccc | sed -e 's:-soname,liblpsolve::')
	if [[ ${actual_soname} != ${SLOT##*/} ]] ; then
		eerror "Actual SONAME: ${actual_soname}"
		eerror "Expected SONAME: ${SLOT##*/}"
		die "Expected SONAME not found! Please update the subslot in the ebuild!"
	fi
}

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
