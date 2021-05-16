# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit epatch flag-o-matic multilib toolchain-funcs

DESCRIPTION="Lightweight scheme interpreter"
HOMEPAGE="http://tinyscheme.sourceforge.net"
SRC_URI="mirror://sourceforge/tinyscheme/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
#KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos ~x64-macos"
KEYWORDS="amd64 ppc x86"
IUSE="static-libs"

DEPEND=""
RDEPEND=""

src_prepare() {

	epatch "${FILESDIR}"/${P}-makefile.patch

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-flags -DOSX
		sed -i \
			-e 's/SOsuf=so/SOsuf=dylib/' \
			-e "s|-Wl,-soname=|-Wl,-install_name=${EPREFIX}/usr/lib/|" \
			makefile || die
	fi
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}"\
		AR=$(tc-getAR) CC=$(tc-getCC)
}

src_install() {

	local tslib=libtinyscheme$(get_libname)
	local tslibx=libtinyscheme$(get_libname ${PV})

	newbin scheme ${PN}

	newlib.so ${tslib} ${tslibx}
	dosym ${tslibx} /usr/$(get_libdir)/${tslib}
	dodoc Manual.txt

	if use static-libs; then
		dolib.a libtinyscheme.a
	fi

	# Bug 328967: dev-scheme/tinyscheme-1.39-r1 doesn't install header file
	insinto /usr/include/
	newins scheme.h tinyscheme.h

	local INIT_DIR=/usr/share/${PN}/
	insinto ${INIT_DIR}
	doins init.scm
	dodir /etc/env.d/ && echo "TINYSCHEMEINIT=\"${EPREFIX}${INIT_DIR}init.scm\"" > "${ED}"/etc/env.d/50tinyscheme
}
