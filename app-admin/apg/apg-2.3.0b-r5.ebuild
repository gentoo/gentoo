# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/apg/apg-2.3.0b-r5.ebuild,v 1.10 2012/12/07 19:00:37 ulm Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Another Password Generator"
HOMEPAGE="http://www.adel.nursat.kz/apg/"
SRC_URI="http://www.adel.nursat.kz/apg/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ppc ~ppc64 x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cracklib"

DEPEND="cracklib? ( sys-libs/cracklib )"
RDEPEND="${DEPEND}"

src_prepare() {
	chmod -R 0700 "${S}"
	if use cracklib; then
		epatch "${FILESDIR}"/${P}-cracklib.patch
		epatch "${FILESDIR}"/${PN}-glibc-2.4.patch
	fi
	epatch "${FILESDIR}"/${P}-crypt_password.patch
}

src_compile() {
	sed -i 's,^#\(APG_CS_CLIBS += -lnsl\)$,\1,' Makefile \
		|| die "Sed failed"
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -i 's,^APG_CLIBS += -lcrypt,APG_CLIBS += ,' Makefile \
		|| die "Sed failed"
	fi

	emake \
		FLAGS="${CFLAGS} ${LDFLAGS}" CFLAGS="${CFLAGS} ${LDFLAGS}" \
		CC="$(tc-getCC)" \
		standalone || die "compile problem"
	emake FLAGS="${CFLAGS} ${LDFLAGS}" CC="$(tc-getCC)" \
		-C bfconvert || die "compile problem"
}

src_install() {
	dobin apg apgbfm bfconvert/bfconvert || die
	dodoc CHANGES INSTALL README THANKS TODO || die
	cd doc
	doman man/apg.1 man/apgbfm.1 || die
	dodoc APG_TIPS pronun.txt rfc0972.txt rfc1750.txt || die
}
