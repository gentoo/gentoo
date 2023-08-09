# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="Lightweight scheme interpreter"
HOMEPAGE="https://tinyscheme.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="static-libs"

RDEPEND=""
DEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-makefile.patch )
DOCS=( CHANGES {Manual,MiniSCHEMETribute,hack}.txt )

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	local tslib=lib${PN}$(get_libname)
	local tslibx=lib${PN}$(get_libname ${PV})

	newbin scheme ${PN}

	newlib.so ${tslib} ${tslibx}
	dosym ${tslibx} /usr/$(get_libdir)/${tslib}
	use static-libs && dolib.a lib${PN}.a
	einstalldocs

	# bug #328967
	insinto /usr/include
	newins scheme.h ${PN}.h

	local INIT_DIR=/usr/share/${PN}
	insinto ${INIT_DIR}
	doins init.scm
	dodir /etc/env.d
	echo "TINYSCHEMEINIT=\"${EPREFIX}${INIT_DIR}/init.scm\"" >"${ED}"/etc/env.d/50${PN}
}
