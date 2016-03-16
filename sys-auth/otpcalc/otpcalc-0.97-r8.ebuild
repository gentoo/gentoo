# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A One Time Password and S/Key calculator for X"
HOMEPAGE="http://killa.net/infosec/otpCalc/"
SRC_URI="http://killa.net/infosec/otpCalc/otpCalc-${PV}.tar.gz
	https://dev.gentoo.org/~ulm/distfiles/${P}-patches-1.tar.xz"

LICENSE="GPL-2+" # bundled crypto functions are not used
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"

RDEPEND="x11-libs/gtk+:2
	dev-libs/openssl:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/otpCalc-${PV}"

src_prepare() {
	eapply ../patch
	eapply_user

	# override hardcoded FLAGS
	sed -i \
		-e 's:$(CC) $(CFLAGS) $^:$(CC) $(LDFLAGS) $(CFLAGS) $^:' \
		-e "s#-s -O3#${CFLAGS}#g" \
		Makefile.in || die

	tc-export CC
}

src_compile() {
	emake otpCalc otpCalc.1
}

src_install() {
	dobin otpCalc
	dosym otpCalc /usr/bin/otpcalc
	doman otpCalc.1
	newman - otpcalc.1 <<< ".so man1/otpCalc.1"
	insinto /usr/share/applications
	doins "${FILESDIR}/${PN}.desktop"
	dodoc BUGS ChangeLog TODO
}
