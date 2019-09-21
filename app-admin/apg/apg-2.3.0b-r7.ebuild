# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Another Password Generator"
HOMEPAGE="http://www.adel.nursat.kz/apg/"
SRC_URI="http://www.adel.nursat.kz/apg/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cracklib"

DEPEND="cracklib? ( sys-libs/cracklib )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	if use cracklib; then
		eapply "${FILESDIR}"/${P}-cracklib.patch
	fi
	eapply "${FILESDIR}"/${PN}-glibc-2.4.patch
	eapply "${FILESDIR}"/${P}-crypt_password.patch

	sed -i 's,^#\(APG_CS_CLIBS += -lnsl\)$,\1,' Makefile \
		|| die "Sed failed"
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -i 's,^APG_CLIBS += -lcrypt,APG_CLIBS += ,' Makefile \
			|| die "Sed failed"
	fi
}

src_compile() {
	emake \
		FLAGS="${CFLAGS} ${LDFLAGS}" CFLAGS="${CFLAGS} ${LDFLAGS}" \
		CC="$(tc-getCC)" standalone
	emake FLAGS="${CFLAGS} ${LDFLAGS}" CC="$(tc-getCC)" \
		-C bfconvert
}

src_install() {
	dobin apg apgbfm bfconvert/bfconvert
	dodoc CHANGES INSTALL README THANKS TODO \
		doc/{APG_TIPS,pronun.txt,rfc0972.txt,rfc1750.txt}
	doman doc/man/{apg.1,apgbfm.1}
}
